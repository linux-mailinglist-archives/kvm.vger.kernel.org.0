Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3EF6387C0
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 11:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiKYKn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 05:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKYKnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 05:43:55 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1CAD1F9E6
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:43:53 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1867A23A;
        Fri, 25 Nov 2022 02:44:00 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E6283F73D;
        Fri, 25 Nov 2022 02:43:52 -0800 (PST)
Date:   Fri, 25 Nov 2022 10:43:41 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Subject: Re: [PATCH kvmtool v1 08/17] Use memfd for all guest ram allocations
Message-ID: <Y4CcXf5qQUlwHBPb@monolith.localdoman>
References: <20221115111549.2784927-1-tabba@google.com>
 <20221115111549.2784927-9-tabba@google.com>
 <Y39PCG0ZRHf/2d5E@monolith.localdoman>
 <CA+EHjTx6JRODjncxMz6pBO43S2gAFZt4vDibG=Zwbr7TkbiFeQ@mail.gmail.com>
 <Y3+meXHu5MRYuHou@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3+meXHu5MRYuHou@monolith.localdoman>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Did some digging, correction(s) below.

On Thu, Nov 24, 2022 at 05:14:33PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Nov 24, 2022 at 03:19:34PM +0000, Fuad Tabba wrote:
> > [..]
> > kvmtool closer to a more consistent way of allocating guest memory, in
> > a similar manner to other VMMs.
> 
> I would really appreciate pointing me to where qemu allocates memory using
> memfd when invoked with -m <size>. I was able to follow the hostmem-ram
> backend allocation function until g_malloc0(), but I couldn't find the
> implementation for that.

As far as I can tell, qemu allocates memory without backing storage (so by
specifying only -m on the command line) like this:

main -> qemu_init -> qmp_x_exit_preconfig -> qemu_init_board ->
create_default_memdev, which creates a TYPE_MEMORY_BACKEND_RAM object.

When creating the VM ram, the object's alloc function is called in:

create_default_memdev -> user_creatable_complete ->
host_memory_backend_complete) -> ram_backend_memory_alloc ->
memory_region_init_ram_flags_nomigrate -> qemu_ram_alloc ->
qemu_ram_alloc_internal -> ram_block_add -> qemu_anon_ram_alloc ->
qemu_ram_mmap(fd=-1,..) -> mmap_activate(..,fd=-1,..) ->
mmap(..,MAP_ANONYMOUS,fd=-1,..)

Unless I'm mistaken with the above (it was quite convoluted to unwrap all
of this), qemu doesn't allocate RAM for the VM using a backing file, unless
specifically requested by the user.

On the other hand. for crosvm:

main -> crosvm_main -> run_vm -> run_config (from src/scrovm/sys/unix.rs),
creates the memory layout in GuestMemory::new ->
MemoryMappingBuilder::new -> from_shared_memory -> offset -> build.

I couldn't find the implementation for MemoryMappingBuilder::build, if it's
anything like build_fixed, then indeed it looks like it uses the memfd
created with GuestMemory::create_shm and passed to
MemoryMappingBuild::from_shared_offset.

Thanks,
Alex
