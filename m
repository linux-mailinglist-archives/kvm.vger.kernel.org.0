Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F6243CD8C
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 17:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242783AbhJ0PdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 11:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242768AbhJ0PdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 11:33:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC91BC061570
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 08:30:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a26so3032670pfr.11
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 08:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8HVWDdXXt0AD/xSFizk+AYjOVZmIDbS9XwzvKXYRSt8=;
        b=OEfG9fsgSPXFsuD00eYA/4hb/4nOJhqt3Fa3DsCVNZsfitbSN/e7Fn81m4qSyNF6U/
         mhh/R9TUBiF7pjmngLNdEADzgfxtm/aVHY0H9J+z6ozxZ49ZZu8j36ZA8vNS+jc3P4K8
         39l9ZJZa9RV8xzTd4Pq6XBto9wKnNJruu9xTNPgxAnhf+lq+LyLyNX9Nl8mvXteW2N67
         +TcMWmCTLvtk136TTAc8/TraiE87+QKjoC7eTJ2OAuWqRKMp2hqkYHzHc/UrtgHJUjNB
         S90jgPj6NxctTlEeFg16F+/ojMD4VkEXJciV+yM/BHrhD9Juzesc0Jpe/IsL5krJCSuw
         Hz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8HVWDdXXt0AD/xSFizk+AYjOVZmIDbS9XwzvKXYRSt8=;
        b=T9IP9ZIO6RN41q8He00KU80JiY2rY43rj5qVrTHATT4N3NJzjMRmlfXr5Q1zZZGYMc
         LSV9N6gaEdqUsQDylJW953dAUg1XLMng0clDcxdHxZt/DJlhOGT4hdXyk7fnkRMwlMB/
         Xxi0Od3IAZxUdqmgvquDD6gNPoUDzKWrfBYqRMTI2h58GBbcCScd4XiO2UZG6nHciyXk
         fnfeG3wx7aDXcAoSLqhE8/x7sXmiJLQTXzrHMYnYixvqGBGt9Stn1BDqb3tusY1c2Uav
         K3DPdwt9GiO7lGxJi10qmoKTGnShc65Goity21+9tO9l0g9OG63QPgAbCyqb5MlPgjwS
         wI/A==
X-Gm-Message-State: AOAM531Z3B5Jhl1f8d+ZaeWl/BDB/F9p4SSKbn99HNFSVyObEf99LVdH
        CZeq6BuhoMQnOf12p/KewlC1SQ==
X-Google-Smtp-Source: ABdhPJxZ0e6i7j4AtLY0aYMSXG5aUrKCFCUTxCqVHzekft57NleHTTPCd6QukrG2yYLrBLX5jK+rLA==
X-Received: by 2002:a63:698a:: with SMTP id e132mr24303698pgc.434.1635348638933;
        Wed, 27 Oct 2021 08:30:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w11sm180048pge.48.2021.10.27.08.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 08:30:38 -0700 (PDT)
Date:   Wed, 27 Oct 2021 15:30:34 +0000
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
Subject: Re: [PATCH v2 40/43] KVM: VMX: Wake vCPU when delivering posted IRQ
 even if vCPU == this vCPU
Message-ID: <YXlwmrrRVIoaU2kG@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-41-seanjc@google.com>
 <a2a4e076-edb8-2cb5-5cb2-6825a1a4559a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2a4e076-edb8-2cb5-5cb2-6825a1a4559a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > 
> > Lastly, this aligns the non-nested and nested usage of triggering posted
> > interrupts, and will allow for additional cleanups.
> 
> It also aligns with SVM a little bit more (especially given patch 35),
> doesn't it?

Yes, aligning VMX and SVM APICv behavior as much as possible is definitely a goal
of this series, though I suspect I failed to state that anywhere.
