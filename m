Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B793CE8B1F
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 15:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbfJ2Oqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 10:46:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389512AbfJ2Oqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 10:46:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RVTpthZrHOk7IfLlraARIfc31SOuZLAE6ydkjHgKOcc=; b=VBETDdIaJ9d4Kg2mBfL/M1TGR
        eUYCl+nNSz71wJs920Z0n64YWcZAJGzYUcMNsQJdIPNuhsCPRJ5KJ72h6kXD5kYJmNEB31xpDKJFa
        K7nbPjkOSqAEYw9hu/hGuRPdH01tgOanjbAiy7TvSa993ePpQrLOaPpxTxFuXHpS2aFBRxuCL2FV6
        N4+Ze4yl5QQHOWDGL2+usWp4Fc6WLCTnEr+OwLQaetPqbQCX3l1fHkKZgfnWZcEsRoX/A3zgNISER
        FZDnkwC33AY0HEpFJt/b52tWsh7LUf3shvnfORX8QA4TJHPgOQa/Ll/jqVNJaYLfTyKTDDFrjN2gQ
        a+j+YTNnQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPSlH-0001hq-1P; Tue, 29 Oct 2019 14:46:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E7601306091;
        Tue, 29 Oct 2019 15:45:11 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AE29120D7FEEB; Tue, 29 Oct 2019 15:46:12 +0100 (CET)
Date:   Tue, 29 Oct 2019 15:46:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org
Subject: Re: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Message-ID: <20191029144612.GK4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 27, 2019 at 07:11:12PM -0400, Luwei Kang wrote:
 @@ -99,7 +99,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
>  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  				  unsigned config, bool exclude_user,
>  				  bool exclude_kernel, bool intr,
> -				  bool in_tx, bool in_tx_cp)
> +				  bool in_tx, bool in_tx_cp, bool pebs)
>  {
>  	struct perf_event *event;
>  	struct perf_event_attr attr = {
> @@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		.exclude_user = exclude_user,
>  		.exclude_kernel = exclude_kernel,
>  		.config = config,
> +		.precise_ip = pebs ? 1 : 0,
> +		.aux_output = pebs ? 1 : 0,

srsly?
