Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF85793F28
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 16:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbjIFOoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 10:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjIFOoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 10:44:25 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE77C92
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 07:44:21 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bf681d3d04so41860115ad.2
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694011461; x=1694616261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SSTiKL7WWCo51b+iExLvIaKWw3Z08VsIyzSrL3/Ne10=;
        b=YNY47AudHlnoEtwGMp3p0O/J43zt2FZgeep8TEp0qJhNaqeNecUuH9VUI0ZObp7r1A
         ztvX0VvHdhsT3i0HHwCiYJ3ccUtJ8YiBKOobKsBbwXEzV0KjOlgiSExRHGDr0VLbLX5/
         mtk9Rx1PgYQYSwuhCv7X/Lp+mWMciViGeHg0w+OBykp8S7bfrWgrXGSanXtpu5zeDgmB
         q8YhNj+Smi+bFLHeg4FDRitXQ3fzq0q6R+QFZK1JTr5sZXwj4/nTKFBk2WyuLbI0qIGE
         SXR1d+B4u8JXE3/hEo1xVEiT2OluJJ5Lo144usBxgg8L9jwJWzjVb9bsDZcoSCRxcYzk
         i4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694011461; x=1694616261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSTiKL7WWCo51b+iExLvIaKWw3Z08VsIyzSrL3/Ne10=;
        b=hxaJpUiYyqt6k5hywYooTqeDEeR0rn+fL78MzgswFsIP/c77Cr1Ve7c1uH2f2v5z9+
         yacUcLKz0SdJU33XrsNpv1PlzMhkFRb4GkTVc++Hui+DZRQKp177yPKiYR+7DiH9++9W
         FnoFCgMR4oj5EnVgGNelOZze32N9P3N5VN1fUdQW9OuzxW0/+FYFJphQxWP871Jiw4YJ
         PWT92CbpBnK86g3AGoHbuja4/PU/x0YD7sQAhxbRoxruNIHk5sjUwt8rJBblPyC9PVSq
         ZLDVgHzKgN1Zq4MiMgUDNGg54mx+UOMDf3nNtU5MaTO6HAA0vSW8tRCTqN8//YHREedO
         4lkg==
X-Gm-Message-State: AOJu0Yx8e7z2WlEHTuogydP0LtOwxfFbRXecx7F2VBJcAIR4BMucsqHO
        TmsK2fONFIjuQmSpWyLh1i9hL3xfo0k=
X-Google-Smtp-Source: AGHT+IFj9NCYL1vWVS35pRCYY8NqINJEP03nOf/Bp5WA8N+2YUIJEI/6471Uli0EjqFcCGVeG3StcK5OIQw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88b:b0:1b8:8c7:31e6 with SMTP id
 w11-20020a170902e88b00b001b808c731e6mr5385581plg.1.1694011461320; Wed, 06 Sep
 2023 07:44:21 -0700 (PDT)
Date:   Wed, 6 Sep 2023 07:44:19 -0700
In-Reply-To: <5ff1591c-d41c-331f-84a6-ac690c48ff5d@arm.com>
Mime-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com> <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
 <ZPd6Y9KJ0FfbCa0Q@google.com> <5ff1591c-d41c-331f-84a6-ac690c48ff5d@arm.com>
Message-ID: <ZPiQQ0OANuaOYdIS@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Robin Murphy wrote:
> On 2023-09-05 19:59, Sean Christopherson wrote:
> > And if the driver *doesn't* initialize the data, then the copy is at best pointless,
> > and possibly even worse than leaking stale swiotlb data.
> 
> Other than the overhead, done right it can't be any worse than if SWIOTLB
> were not involved at all.

Yep.

> > Looking at commit ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE"),
> > IIUC the data leak was observed with a synthetic test "driver" that was developed
> > to verify a real data leak fixed by commit a45b599ad808 ("scsi: sg: allocate with
> > __GFP_ZERO in sg_build_indirect()").  Which basically proves my point: copying
> > from the source only adds value absent a bug in the owning driver.
> 
> Huh? IIUC the bug there was that the SCSI layer failed to sanitise
> partially-written buffers. That bug was fixed, and the scrutiny therein
> happened to reveal that SWIOTLB *also* had a lower-level problem with
> partial writes, in that it was corrupting DMA-mapped memory which was not
> updated by the device. Partial DMA writes are not in themselves indicative
> of a bug, they may well be a valid and expected behaviour.

The problem is that the comment only talks about leaking data to userspace, and
doesn't say anything about data corruption or the "swiotlb needs to match hardware"
justification that Linus pointed out.  I buy both of those arguments for copying
data from the original page, but the "may prevent leaking swiotlb content" is IMO
completely nonsensical, because if preventing leakage is the only goal, then
explicitly initializing the memory is better in every way.

If no one objects, I'll put together a patch to rewrite the comment in terms of
mimicking hardware and not corrupting the caller's data.

> > IMO, rather than copying from the original memory, swiotlb_tbl_map_single() should
> > simply zero the original page(s) when establishing the mapping.  That would harden
> > all usage of swiotlb and avoid the read-before-write behavior that is problematic
> > for KVM.
> 
> Depends on one's exact definition of "harden"... Corrupting memory with
> zeros is less bad than corrupting memory with someone else's data if you
> look at it from an information security point of view, but from a
> not-corrupting-memory point of view it's definitely still corrupting memory
> :/
> 
> Taking a step back, is there not an argument that if people care about
> general KVM performance then they should maybe stop emulating obsolete PC
> hardware from 30 years ago, and at least emulate obsolete PC hardware from
> 20 years ago that supports 64-bit DMA?

Heh, I don't think there's an argument per se, people most definitely shouldn't
be emulating old hardware if they care about performance.  I already told Yan as
much.

> Even non-virtualised, SWIOTLB is pretty horrible for I/O performance by its
> very nature - avoiding it if at all possible should always be preferred.

Yeah.  The main reason I didn't just sweep this under the rug is the confidential
VM use case, where SWIOTLB is used to bounce data from guest private memory into
shread buffers.  There's also a good argument that anyone that cares about I/O
performance in confidential VMs should put in the effort to enlighten their device
drivers to use shared memory directly, but practically speaking that's easier said
than done.
