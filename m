Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813A8638809
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 11:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiKYK7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 05:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiKYK7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 05:59:15 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22199490A6
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:59:13 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id c1so6312338lfi.7
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fmtbF+EN5Xe9ks/m4Yv6D+1Jc/X9oB2TCJjsWLH7e4o=;
        b=RfLF3aEXaHhLqQvB3MzvqQmalaLI0m2eGXOlbyxciNtw3n/PCTMhhl9Ojb9AGjNgQD
         jEmIX4aYvI9ecvd7ZQPML9Ke0Cqx59Gi23S17lPWDzbxj8r7dxqBQAhF0T0AmBzzLpQ3
         D5Il7mTaqXCDStCUoLs99baVTBwgj7HkAueEtC0GjzfvLD9wDkPIhz34K3BwfhfB1o6J
         awGaZkES9ktlfBbCKE/ZmnTjDhTEi1g+zpOzFKIu3AFzETJeMYerOf2AcbJhjg0jTokd
         wE7JgPOwmAz2QUCGoDE/M0qK9wTPgtVL9GsWqETI5BFPP6LxpoudAQgq5icZ5s109lx7
         DQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmtbF+EN5Xe9ks/m4Yv6D+1Jc/X9oB2TCJjsWLH7e4o=;
        b=69+Hzr0YgjZD9FlMSqprZ6foRTNQ/3XfJGSyTgI9qxsI4DV7SJY7lh2VUMtla0i/Bz
         AWfF5dCew5eQVTGZ4A8r0pLi/olAxtdNp/AL96SAwbgNe54+NPtjLV+5DQ+3oRVm7XbL
         BNXi4+OXZBVdUBx89s3MJ6k/u0kH20W/b/O07yJ5U9qQSIJaWl5QyT0MDpfevL+fdgCB
         Bc2iAt+EkeztdazQkGluysBKdQA8S+oPz05lb4JMwpFrzvaK/gmQmJr2kZ4dYYIIN1ZS
         cdK18McJCsxIIIG9q48TSLCLgPKj22e2rdo7tCU4B3auppL/yiCDd+dkrZg57lpsOBYC
         xhBA==
X-Gm-Message-State: ANoB5pkkTn8/8xd3Eci3o3F15xKXP9mqc06OJNK/MvtFumuotPfXPArs
        71KlKTJwqMj5jhccU0rqFKKCRaKnx1GoJ6FTsFzTFg==
X-Google-Smtp-Source: AA0mqf6VWVm6AuScRVtWu/HVe92+x3A2Z+Aj7iXvaQO/89AArYRL7f3Y1zbUdSzRdQe2kKjSFPc7Wc19fcoDzQ4NA24=
X-Received: by 2002:a05:6512:3147:b0:4a7:7daf:905b with SMTP id
 s7-20020a056512314700b004a77daf905bmr12038387lfi.665.1669373951287; Fri, 25
 Nov 2022 02:59:11 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-9-tabba@google.com>
 <Y39PCG0ZRHf/2d5E@monolith.localdoman> <CA+EHjTx6JRODjncxMz6pBO43S2gAFZt4vDibG=Zwbr7TkbiFeQ@mail.gmail.com>
 <Y3+meXHu5MRYuHou@monolith.localdoman> <Y4CcXf5qQUlwHBPb@monolith.localdoman>
In-Reply-To: <Y4CcXf5qQUlwHBPb@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 25 Nov 2022 10:58:35 +0000
Message-ID: <CA+EHjTztrN+fqKzvs6+NN6n0V0_80yJvmXao2R87DtTZtRfVnA@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 08/17] Use memfd for all guest ram allocations
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Nov 25, 2022 at 10:43 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> Did some digging, correction(s) below.
>
> On Thu, Nov 24, 2022 at 05:14:33PM +0000, Alexandru Elisei wrote:
> > Hi,
> >
> > On Thu, Nov 24, 2022 at 03:19:34PM +0000, Fuad Tabba wrote:
> > > [..]
> > > kvmtool closer to a more consistent way of allocating guest memory, in
> > > a similar manner to other VMMs.
> >
> > I would really appreciate pointing me to where qemu allocates memory using
> > memfd when invoked with -m <size>. I was able to follow the hostmem-ram
> > backend allocation function until g_malloc0(), but I couldn't find the
> > implementation for that.
>
> As far as I can tell, qemu allocates memory without backing storage (so by
> specifying only -m on the command line) like this:
>
> main -> qemu_init -> qmp_x_exit_preconfig -> qemu_init_board ->
> create_default_memdev, which creates a TYPE_MEMORY_BACKEND_RAM object.
>
> When creating the VM ram, the object's alloc function is called in:
>
> create_default_memdev -> user_creatable_complete ->
> host_memory_backend_complete) -> ram_backend_memory_alloc ->
> memory_region_init_ram_flags_nomigrate -> qemu_ram_alloc ->
> qemu_ram_alloc_internal -> ram_block_add -> qemu_anon_ram_alloc ->
> qemu_ram_mmap(fd=-1,..) -> mmap_activate(..,fd=-1,..) ->
> mmap(..,MAP_ANONYMOUS,fd=-1,..)
>
> Unless I'm mistaken with the above (it was quite convoluted to unwrap all
> of this), qemu doesn't allocate RAM for the VM using a backing file, unless
> specifically requested by the user.

Thanks and sorry that you had to do some digging because of my mistake
(thinking that the memfd backend was the default one).

Cheers,
/fuad

> On the other hand. for crosvm:
>
> main -> crosvm_main -> run_vm -> run_config (from src/scrovm/sys/unix.rs),
> creates the memory layout in GuestMemory::new ->
> MemoryMappingBuilder::new -> from_shared_memory -> offset -> build.
>
> I couldn't find the implementation for MemoryMappingBuilder::build, if it's
> anything like build_fixed, then indeed it looks like it uses the memfd
> created with GuestMemory::create_shm and passed to
> MemoryMappingBuild::from_shared_offset.
>
> Thanks,
> Alex
