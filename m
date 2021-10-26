Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D335543B4BC
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 16:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhJZOud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 10:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbhJZOub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 10:50:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00F6C061767
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 07:48:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id y1-20020a17090a134100b001a27a7e9c8dso2096084pjf.3
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 07:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t+GavL7jaDIOLO9+HWOF0JpCL4n+9982OXgOJJO3B68=;
        b=mMtlNqAGEx5moOXiuoulPA91tzGA7QXfJoC+FMrgS7kXKDaeQEPhlrtU0/6hIAVeF6
         4XgOag3S8f64bxtieFkoj/CBTBoyg71uy6bYxr2fBQK7J8y0qvj3yp4nxsZiGo0ugwoy
         chqWhQbdF2M/ss8dRD5cMeGRjF2i7TFbnWAE4XD/Gn+/ew4eCp8tBNWFi6mKqTjGiuSB
         4K+eMtDT8TA09mAfuKwzPO/bGE/KLqBK8ggRwFAk21MDpCSdzSupIOVWDECUMDk9Gucp
         WDZDdD8wswuh2DToiC42rEb1Gvw+Zc82wwd7L/2Pn0t+7EwhXqTAcJo8pcrg6fGfmqKg
         9NUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t+GavL7jaDIOLO9+HWOF0JpCL4n+9982OXgOJJO3B68=;
        b=Rgm/oaWv+KH9HgdBfUdreWwugbVTMXhvttGQuVeoGmeB9gLhd4E24kOAwU4CtpTzk3
         cU2hUO58+a6WzaQafIKL9LuCqXWRJaAY87AN0lg23ZV97Ra70GSZu+osDwS9zlQn8D+Y
         9I4y8HD4JPZ1ZwY04r7c2m//QAjd3jtrRbQwY2S3gQ+04hchWoM+faOTzTOoj5rtAt5t
         AIq7zvUrhJUvHg6hlTnF/l6OwfXinV6Cl1FrYEol9fYzkJWCCGWOHXpddNvD8mHzGOAt
         Pe4jypi0aVUcl/K5RlRTLhZEjDt3ZyWsnYZ1KkMP6/tGdt8hdgtyN/dybY6vxDrGDvBG
         Y3hg==
X-Gm-Message-State: AOAM530DCoJzjSpcDrWm9Lnu3r4DaX8yVG8yFu+fhFitW8ti0FW8Wevc
        3H7QnvjAUeBtblkulqyWyEfFEA==
X-Google-Smtp-Source: ABdhPJwehmwFySoaS1hi2p+T+LiAO8upF6izWYrpOOMtkZkPW5L2hiCqpK0gC/Rhqd0TA7qN0BGQqw==
X-Received: by 2002:a17:902:e88a:b0:140:25a7:4a1b with SMTP id w10-20020a170902e88a00b0014025a74a1bmr22402882plg.67.1635259687236;
        Tue, 26 Oct 2021 07:48:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id fy8sm186294pjb.47.2021.10.26.07.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:48:06 -0700 (PDT)
Date:   Tue, 26 Oct 2021 14:48:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
Message-ID: <YXgVIvYhABnrP2Jo@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <04b1a72e-47b4-4bde-eb9e-ba36c156ff0d@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04b1a72e-47b4-4bde-eb9e-ba36c156ff0d@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 26, 2021, Christian Borntraeger wrote:
> Am 09.10.21 um 04:11 schrieb Sean Christopherson:
> > This is basically two series smushed into one.  The first "half" aims
> > to differentiate between "halt" and a more generic "block", where "halt"
> > aligns with x86's HLT instruction, the halt-polling mechanisms, and
> > associated stats, and "block" means any guest action that causes the vCPU
> > to block/wait.
> > 
> > The second "half" overhauls x86's APIC virtualization code (Posted
> > Interrupts on Intel VMX, AVIC on AMD SVM) to do their updates in response
> > to vCPU (un)blocking in the vcpu_load/put() paths, keying off of the
> > vCPU's rcuwait status to determine when a blocking vCPU is being put and
> > reloaded.  This idea comes from arm64's kvm_timer_vcpu_put(), which I
> > stumbled across when diving into the history of arm64's (un)blocking hooks.
> > 
> > The x86 APICv overhaul allows for killing off several sets of hooks in
> > common KVM and in x86 KVM (to the vendor code).  Moving everything to
> > vcpu_put/load() also realizes nice cleanups, especially for the Posted
> > Interrupt code, which required some impressive mental gymnastics to
> > understand how vCPU task migration interacted with vCPU blocking.
> > 
> > Non-x86 folks, sorry for the noise.  I'm hoping the common parts can get
> > applied without much fuss so that future versions can be x86-only.
> > 
> > v2:
> >   - Collect reviews. [Christian, David]
> >   - Add patch to move arm64 WFI functionality out of hooks. [Marc]
> >   - Add RISC-V to the fun.
> >   - Add all the APICv fun.
> 
> Have we actually followed up on the regression regarding halt_poll_ns=0 no longer disabling
> polling for running systems?

No, I have that conversation flagged but haven't gotten back to it.  I still like
the idea of special casing halt_poll_ns=0 to override the capability.  I can send
a proper patch for that unless there's a different/better idea?
