Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44241B2DB
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 17:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbhI1PWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 11:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241443AbhI1PWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 11:22:34 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A563C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 08:20:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 75so5157624pga.3
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 08:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lwHAIgEq4+Z86k7pIcyJFqJO0ELIjKqg924eVGRn0Ew=;
        b=qDDhUYAovjPxp+JLVPciXG9blp4tRpcL+sFvS6yk4ykWNN1ycgApfJOM2eUcyGR8ej
         ZUHR+UYQ4TfkIQDebIVV3yr5GjT4xd3oshBdb3wjh3orDNI823t+/Y0A5UP1JP2D00Ho
         2t+hMTei3vkoBBDQ2nSDUR+465eyz1ZrNtzKDXAwOAIxixDedIpgnWZE93viQk+4Lj3d
         V6oV3JW1bninbp4XUmP8kNZwFR3Pr1MIx9+qlbXf1f5SYGM6I1JRBxjtQfrqTQFZObMi
         jNbtV65dMX1T11yXFW65Mtr9/UPdl9BMEYV/YEnuR3cOqAbxPexPIFPSBUsKeEMci+u/
         zA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lwHAIgEq4+Z86k7pIcyJFqJO0ELIjKqg924eVGRn0Ew=;
        b=woNKWjz6yzSjBazybSIFYwtFZzfwGBqBRgQm0a4dY8sYsJAOpu2mMQY9GTPDt7PG4E
         bnfMkkAznTCTkz3J1I6r9RZSrE4S9xSmesw/X+4Qc/w5a6N4+TH5lYmxgtNAJY4ys0Ki
         /Bnga4SaH5rdSUCsZmVKaKoDLrjgTlJzXRjkWT/HT7KlAHivbS/IiUZuet//f9bd8BgZ
         dM9IUFaPYOXfHZw+JgmCWav+WsGfTRX0EgIPyacxl5+O+2VTUlUSAW/7IjmIn4KboAqD
         shU8P7WEqvzei7V98buvVRksrSzl+oOQauNixoachQcSgxi3LZjVOHItVCS3jU06+BJ/
         O4Nw==
X-Gm-Message-State: AOAM532BkTOQxh+1k2AjlM27EVf1bGkZHzSl6cQuDlcDSWZIzmMmeOv5
        7y+TfjQ618EuB3yftgVQ814sKw==
X-Google-Smtp-Source: ABdhPJz1+8rpvALog3DRUjd5Q8aGHAUZp7aj1oTqoH/EzuELbFpRF0kFQuRE4VMFljkB69MSIOoyug==
X-Received: by 2002:aa7:953d:0:b0:438:c168:df09 with SMTP id c29-20020aa7953d000000b00438c168df09mr5827013pfp.59.1632842454723;
        Tue, 28 Sep 2021 08:20:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q11sm2975189pjf.14.2021.09.28.08.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 08:20:54 -0700 (PDT)
Date:   Tue, 28 Sep 2021 15:20:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <YVMy0uzfSNrUo+Ur@google.com>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <20210924064732.xqv2xjya3pxgmwr2@gator.home>
 <YVIj+gExrHrjlQEm@google.com>
 <20210928072409.ks6b6u3rs7qngije@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928072409.ks6b6u3rs7qngije@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021, Andrew Jones wrote:
> On Mon, Sep 27, 2021 at 08:05:14PM +0000, Sean Christopherson wrote:
> > My vote would be to rework arm64's ucall_init() as a prep patch and drop the param
> > in the process.  There are zero tests that provide a non-NULL value, but that's
> > likely because tests that care deliberately defer ucall_init() until after memory
> > regions and page tables have been configured.
> > 
> > IMO, arm64's approach is unnecessarily complex (that's a common theme for KVM's
> > selftests...).  The code attempts to avoid magic numbers by not hardcoding the MMIO
> > range, but in doing so makes the end result even more magical, e.g. starting at
> > 5/8ths of min(MAX_PA, MAX_VA).
> > 
> > E.g. why not put the ucall MMIO range immediately after the so called "default"
> > memory region added at the end of vm_create()?  That way the location of the ucall
> > range is completely predictable, and while still arbitrary, less magical.
> >
> 
> While we do hardcode zero as the guest physical base address, we don't
> require tests to use DEFAULT_GUEST_PHY_PAGES for slot0. They only get
> that if they use vm_create_default* to create the vm. While trying to
> keep the framework flexible for the unit tests does lead to complexity,
> I think the ucall mmio address really needs to be something that can move.

Rats, I had contradicting information in my reply.  Ignore the part about dropping
the param.  My intended suggestion was to dynamically place the ucall range after
the default region, i.e. it would float around, but the relative location is fixed.

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..0ec2de586bf7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -315,6 +315,8 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
                vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
                                            0, 0, phy_pages, 0);

+       ucall_init(0 + <size of default region>);
+
        return vm;
 }

> It's not part of the test setup, i.e. whatever the unit test wants to
> test, it's just part of the framework. It needs to stay out of the way.

Sort of.  In this specific case, I think it's the tests' responsibility to not
stomp over the ucall region as much as it's the framework's responsibility to not
select a conflicting range.  Arch-agnostic tests _can't_ care about absolute
addresses, and we done messed up if we pick a ucall range that is at all
interesting/unique on arm64.

The problem with the current approach is that it's unnecessarily difficult for
either side to do the right thing.  The framework should not have to search
memory regions, and test writers should be given simple (and documented!) rules
for what memory regions are reserved by the framework.
