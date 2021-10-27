Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3343CC24
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238400AbhJ0O3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbhJ0O3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 10:29:09 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0738C0613B9
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 07:26:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n11so2133610plf.4
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 07:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LMqODRZlF8nHhJs02sWnsNzJB8DCwjwV772Lcvk4X9o=;
        b=iWwrbnSH9Fky5OxBApAzRFVpTKOaMHDs7Xrzkqa4bfHRvpB9pNrmqtwX5XStYSbIol
         NG6pr6of1LmRK/X8yeBvBQ0Fz8uYI6sCKWIvgmckbalOjA8rZIStxifaaVVG+5EdlLz8
         2ckfTI/AHFWKc1rHQsrwcPVdrkLnqwK/drtGVgppY9agtMGjOEk436kI8PMz0SqSkGNT
         dkWDCvrzCBVDPIbGEr6AdGS2sCg8RuoXUFOHg6zS7uI1OSE10fKTNRuuwKsMoNZNiFkf
         iPVMGJAgypYBjZDhK8mjFm7rCt98R0DWG7pkzdEiPhkk3mMy819HFjaZfkrakLKQ8KAR
         Wy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LMqODRZlF8nHhJs02sWnsNzJB8DCwjwV772Lcvk4X9o=;
        b=hPEXMByN2WqUNk7/7DN62KV9DDFomYHEZ3uqS3Hr1iLOfnXfdt/TO612lBs/SFRDG8
         3+YyIlNEx8VdDqmUJ+T7noxqJ9HeL3+YAizo9YhbAb1DTgrBtk3pX9utjINB0IREzDew
         BHnsiA+HwnJtNsCGlquWh2GY+dMfSJuM2iHWREE57TPZUyS8cA6DmFaxQM08REG4SiZs
         dlfG8UiET+5joEtOn+xDnz/RQ4dfPm70cwOJNAYByPwwMPssx06izrAI5UxKC312PX0x
         +d+yC4cXB9WqXyySOQd4ilQovwYk8CavyY6i5bsPwYtQ8sVD/+YGOYsrjDgN5p2QRtGZ
         pGDw==
X-Gm-Message-State: AOAM530huJlR59r7I79BxV75TIitw4cra9Lt8r7P6N31a+/eSnyJxMQR
        QpQl0E/1GsVhOV2nkTQj9o8rEQ==
X-Google-Smtp-Source: ABdhPJzNj2nhULmp/RR7LS0ShzDRkQdxHUhFj7X33pr1fS/jZmoi4Y5oDiGoEdEWKdZH8tXcKWxvmw==
X-Received: by 2002:a17:90b:11c2:: with SMTP id gv2mr5997881pjb.133.1635344802985;
        Wed, 27 Oct 2021 07:26:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n12sm37080pgh.55.2021.10.27.07.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 07:26:42 -0700 (PDT)
Date:   Wed, 27 Oct 2021 14:26:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 24/43] KVM: VMX: Drop pointless PI.NDST update when
 blocking
Message-ID: <YXlhnkp4/XJCCO0R@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-25-seanjc@google.com>
 <18e6a656-f583-0ad4-6770-9678be3f5cf4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18e6a656-f583-0ad4-6770-9678be3f5cf4@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > Don't update Posted Interrupt's NDST, a.k.a. the target pCPU, in the
> > pre-block path, as NDST is guaranteed to be up-to-date.  The comment
> > about the vCPU being preempted during the update is simply wrong, as the
> > update path runs with IRQs disabled (from before snapshotting vcpu->cpu,
> > until after the update completes).
> 
> Right, it didn't as of commit bf9f6ac8d74969690df1485b33b7c238ca9f2269 (when
> VT-d posted interrupts were introduced).
> 
> The interrupt disable/enable pair was added in the same commit that
> motivated the introduction of the sanity checks:

Ya, I found that commit when digging around for different commit in the series
and forgot to come back to this changelog.  I'll incorporate this info into the
next version.

>     commit 8b306e2f3c41939ea528e6174c88cfbfff893ce1
>     Author: Paolo Bonzini <pbonzini@redhat.com>
>     Date:   Tue Jun 6 12:57:05 2017 +0200
> 
>     KVM: VMX: avoid double list add with VT-d posted interrupts
> 
>     In some cases, for example involving hot-unplug of assigned
>     devices, pi_post_block can forget to remove the vCPU from the
>     blocked_vcpu_list.  When this happens, the next call to
>     pi_pre_block corrupts the list.
> 
>     Fix this in two ways.  First, check vcpu->pre_pcpu in pi_pre_block
>     and WARN instead of adding the element twice in the list.  Second,
>     always do the list removal in pi_post_block if vcpu->pre_pcpu is
>     set (not -1).
> 
>     The new code keeps interrupts disabled for the whole duration of
>     pi_pre_block/pi_post_block.  This is not strictly necessary, but
>     easier to follow.  For the same reason, PI.ON is checked only
>     after the cmpxchg, and to handle it we just call the post-block
>     code.  This removes duplication of the list removal code.
> 
> At the time, I didn't notice the now useless NDST update.
> 
> Paolo
> 
> > The vCPU can get preempted_before_  the update starts, but not during.
> > And if the vCPU is preempted before, vmx_vcpu_pi_load() is responsible
> > for updating NDST when the vCPU is scheduled back in.  In that case, the
> > check against the wakeup vector in vmx_vcpu_pi_load() cannot be true as
> > that would require the notification vector to have been set to the wakeup
> > vector_before_  blocking.
> > 
> > Opportunistically switch to using vcpu->cpu for the list/lock lookups,
> > which presumably used pre_pcpu only for some phantom preemption logic.
> 
