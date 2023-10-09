Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45C7BEB3D
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 22:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378545AbjJIUGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 16:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378534AbjJIUGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 16:06:12 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AEAB7;
        Mon,  9 Oct 2023 13:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yQilcMatqexoOCdrHBdsAR2o8PEeqyJV2iNf9DeNghw=; b=adV1xt/ZK6Bqtj0LQ/bha3U9GI
        aEsZoJqrWulQeOakzRc648pAdDzxO2D3pda+G91WAeqESU4ENOJZcu2kkdeDO945Geu4/DXImhrzE
        MmFw2iDYkG0vXDds3RQ+K8/Tan9cNSQSETLIcIicMvk+4vvBhAHUMqCxYLm1pO7tz8aNnp12fBEAP
        144QMOZVgaiWgQNKizg2m5RjiUi8/OWB2qlGsk212S/4/w0imByL7VEu9EfuOtAJlLp5xzsuY8gp1
        Wlplj+iFstLG3W7fnjVNMFxFYsyVA+HEdFmVCJTsTKpW+8uMfy3VQwJ4obMLvuG0/fB6xeaMuEJjz
        J7UjZJfw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpwW0-00HIQZ-1P;
        Mon, 09 Oct 2023 20:06:08 +0000
Date:   Mon, 9 Oct 2023 21:06:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <20231009200608.GJ800259@ZenIV>
References: <20230928180651.1525674-1-pbonzini@redhat.com>
 <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV>
 <ZSQO4fHaAxDkbGyz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSQO4fHaAxDkbGyz@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 07:32:48AM -0700, Sean Christopherson wrote:

> Yeah, we found that out the hard way.  Is using the "secure" variant to get a
> per-file inode a sane approach, or is that abuse that's going to bite us too?
> 
> 	/*
> 	 * Use the so called "secure" variant, which creates a unique inode
> 	 * instead of reusing a single inode.  Each guest_memfd instance needs
> 	 * its own inode to track the size, flags, etc.
> 	 */
> 	file = anon_inode_getfile_secure(anon_name, &kvm_gmem_fops, gmem,
> 					 O_RDWR, NULL);

Umm...  Is there any chance that your call site will ever be in a module?
If not, you are probably OK with that variant.  I don't like the details
of that interface (anon_inode_getfile_secure(), that is), but that's
a separate story and your use wouldn't make things harder to clean up.
