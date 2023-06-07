Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDEB726AFF
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 22:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjFGUVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbjFGUVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 16:21:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5CD2695;
        Wed,  7 Jun 2023 13:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686169269; x=1717705269;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Iy80am0IjcpZU5wkeaklTCrSRzUJtl7rEeZ5aEG4RTs=;
  b=hV6T+AM77usMgUi5R3al4ehA6BX+o6w/J1ukHZk6tbevzhkwho5a2A9S
   o8Gdi/JufHbm5GIzEKKWxIqA/Y48Xz6LonxEQOsej0XTaEQ3KxoLn6Qrm
   vgimHPZewN1cbwEvknZX2Xb9Sof/dXSIFo1RiICKPmRmcmXQGM4f5Not2
   DGTraAhRKpIIO1e4LjDzjS6l6Qm5QjNpTSWc9RQfpNO3B9qLDY9e8rLey
   0MhtGH9SnWFWXA0Pd2ngtTlq9EnM+0vE3lyoSC3WkXdKrljw13ubquyjF
   j1LD0NG76eZ1eouqb66aownbdQtnmg3YLaImFo8N3RmpWw1FBCp/6B02i
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="337460732"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="337460732"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 13:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="774766041"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="774766041"
Received: from unknown (HELO desk) ([10.255.231.181])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 13:20:44 -0700
Date:   Wed, 7 Jun 2023 13:20:38 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Drop unnecessary
 vmx_fb_clear_ctrl_available "cache"
Message-ID: <20230607202038.5vsgsrt724qhxnjd@desk>
References: <20230607004311.1420507-1-seanjc@google.com>
 <20230607004311.1420507-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607004311.1420507-3-seanjc@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 05:43:10PM -0700, Sean Christopherson wrote:
> Now that KVM snapshots the host's MSR_IA32_ARCH_CAPABILITIES, drop the
> similar snapshot/cache of whether or not KVM is allowed to manipulate
> ARCH_CAPABILITIES.FB_CLEAR_CTRL.  The motivation for the cache was

FB_CLEAR_CTRL is a read-only bit, I think you mean
MSR_IA32_MCU_OPT_CTRL.FB_CLEAR_DIS.

> presumably to avoid the RDMSR, e.g. boot_cpu_has_bug() is quite cheap, and
> modifying the vCPU's MSR_IA32_ARCH_CAPABILITIES is an infrequent option
> and a relatively slow path.
> 
> Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM.

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
