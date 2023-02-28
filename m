Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1C6A625F
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjB1WYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjB1WYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:24:44 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C81813DFE;
        Tue, 28 Feb 2023 14:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677623084; x=1709159084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=STI0A1AFpkCRC21VjoiSWa462JcTzWb62vYYOqmcW74=;
  b=FEzQVIZ585VFMGeYsgolBozxZVOCwiIUYn0WanhlG8/dJKjqMMFZHiO8
   JzFYHhOsccDyyWrPCNpbmf0DYY2M2wDaEp7ObHQXqn3g5o0ulf1F6hoFE
   EDtapQECeTnAPtYOC1Cg6HVkvjFuK1vVy0+1YS+KtFzApFEqO48kQGAkH
   s=;
X-IronPort-AV: E=Sophos;i="5.98,223,1673913600"; 
   d="scan'208";a="304044513"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 22:24:35 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 4707A40D97;
        Tue, 28 Feb 2023 22:24:33 +0000 (UTC)
Received: from EX19D002ANA002.ant.amazon.com (10.37.240.152) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 28 Feb 2023 22:24:32 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.6) by
 EX19D002ANA002.ant.amazon.com (10.37.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 28 Feb 2023 22:24:27 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <bp@alien8.de>
CC:     <dave.hansen@linux.intel.com>, <itazur@amazon.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@redhat.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <tglx@linutronix.de>, <x86@kernel.org>, <zulinx86@gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Date:   Tue, 28 Feb 2023 22:24:16 +0000
Message-ID: <20230228222416.61484-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <Y/5oBKi6vjZe83ac@zn.tnic>
References: <Y/5oBKi6vjZe83ac@zn.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.6]
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
 EX19D002ANA002.ant.amazon.com (10.37.240.152)
X-Spam-Status: No, score=-9.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Date:   Tue, 28 Feb 2023 21:45:56 +0100
From:   Borislav Petkov <bp@alien8.de>
> So you mean we should stick *all* CPUID leafs in there just because
> anything can run in guests?
> 
> What is the hypervisor then for?

I'm still a kernel newbie and I don't have a strong opinion for that.
I just thought it would be helpful if the KVM_GET_SUPPORTED_CPUID API
returns the same security information as the host, as long as it is
harmless. I'm inclined to withdraw this patch if it is not worth
enough.

> Really? Says who?
> 
> $ grep -r . /sys/devices/system/cpu/vulnerabilities/
> 
> gives you all you need to know.
> 
> And if something's missing, then I'm listening.

"De facto standard" was too much. I apologize for my incorrect
expression and poor English. What I wanted to say is that the script
was introduced as a useful tool by Intel and SLES and it provides some
additional information (IBRS always-on in this case).
https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/secure-coding/spectre-and-meltdown-checker-script.html
https://documentation.suse.com/sles/15-SP1/html/SLES-all/cha-spectre.html

Best regards,
Takahiro Itazuri

