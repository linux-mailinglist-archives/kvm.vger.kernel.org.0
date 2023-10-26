Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029807D8A44
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 23:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344840AbjJZV2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 17:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjJZV2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 17:28:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C5C0;
        Thu, 26 Oct 2023 14:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698355681; x=1729891681;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8J9BNPgv1m27uO2LItak+IFRE3PymktIEqwgh/yZAck=;
  b=RutCpXCzQa9KFzu8waeeSZT6IpiNNOCnqsj3UIjxR3GJoGtYPt8cVZws
   uUsgbNGreZcDByZVAiHcP124CE/IVcurArFbNhGepNtJ+AiCVLwRDHgXX
   X9CAmB8hyg5i7E9Sdqvx3dfZroj9jRX39HaIder76eO0yAB6LkNiWespb
   P6aYV/oE13RoA3s+Ak/aFi1NwDsfmNaXE2bheZ16RPV7E5mrGKunSIGA2
   OYZutNMNSduZSV58Z/V/1sApfT+gKmPJcwiYfIDGXDJN+xIEhg/hUVq5E
   gYzP9CdxDuhlk1OG1e2FZeeGYPKwgoJJVr1Kk4r3hCnq51kJa2tD6qMbd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="473895758"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="473895758"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 14:27:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="1090716183"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="1090716183"
Received: from paseron-mobl4.amr.corp.intel.com (HELO desk) ([10.209.17.113])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 14:27:21 -0700
Date:   Thu, 26 Oct 2023 14:27:21 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  v3 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231026212721.pukgqvg4izmyfvzv@desk>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-6-52663677ee35@linux.intel.com>
 <ZTq-b0uVyf6KLNV0@google.com>
 <ZTrJa9NFaAORipVL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTrJa9NFaAORipVL@google.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 01:17:47PM -0700, Sean Christopherson wrote:
> Alternatively, and maybe even preferably, this would make it more obvious that
> the two are mutually exclusive and would also be a (very, very) small perf win
> when the mitigation is enabled.

Agree.

> -       vmx_disable_fb_clear(vmx);
> +       if (!cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> +               vmx_disable_fb_clear(vmx);

