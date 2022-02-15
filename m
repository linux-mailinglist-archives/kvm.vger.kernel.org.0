Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612634B6171
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 04:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiBODQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 22:16:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiBODQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 22:16:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A161BAFF4A;
        Mon, 14 Feb 2022 19:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644894980; x=1676430980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ldCTfGNtUkwvgMlh56Aipx6IPRvEXwAZKbeUmQ5Pl0I=;
  b=FbWcqBRyXUpvAUhVl3V8JMmrIePv4mdFzk8CPae7szWIC+fMj1+SxyE9
   bBE0Uq/ZnI0SLijwBbZBCS0uV5PgYja7YTHU9Q+eQ3i/pTzlO7+/65vgA
   V4xaSF7UwiCnCpxMueWCNSbb2ok2p0v9k2TeGMdFsRTjBbq4RHFpyF61t
   2QavOonnLJZNO4D8Sh9uaG1zOzkKcT9i0sXrfPXS8M4CDeFp9jzU8Md3e
   i5FzKFyq4kov7XQ2o8BmiIAovJGTlERwFSOxpyyk1mNFjzc5zS9ukzKDV
   gRY/9RUFvi2GTzOQkDGJmngtKM9ZPvr5AofHM/g3iz95+Qz7R0KOfSpoG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="233785038"
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="233785038"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 19:16:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="485924034"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 19:16:17 -0800
Date:   Tue, 15 Feb 2022 11:27:13 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 09/11] KVM: x86: Treat x2APIC's ICR as a 64-bit register,
 not two 32-bit regs
Message-ID: <20220215032712.GB28478@gao-cwp>
References: <20220204214205.3306634-1-seanjc@google.com>
 <20220204214205.3306634-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204214205.3306634-10-seanjc@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 	case APIC_SELF_IPI:
>-		if (apic_x2apic_mode(apic)) {
>-			kvm_lapic_reg_write(apic, APIC_ICR,
>-					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
>-		} else
>+		if (apic_x2apic_mode(apic))
>+			kvm_x2apic_icr_write(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
>+		else

The original code looks incorrect. Emulating writes to SELF_IPI by writes to
ICR has an unwanted side-effect: the value of ICR in vAPIC page gets changed.

It is better to use kvm_apic_send_ipi() directly.
