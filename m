Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AB16A6079
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjB1UjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjB1UjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:39:04 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D9D34C3B;
        Tue, 28 Feb 2023 12:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677616743; x=1709152743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rl35dc1iPnbWuVVxE9D4Cxh5CG/w80f3pFsgYUgu3M8=;
  b=iu0vx/w7ByuM3K5svEztWEhgkrnQ4GVe/WOpMszve4lXG+A8HgHP+X3N
   sL6Nj2/13f7orx3sLtzqCBYgN3IkqLnatJ/0C/Dc3msU9ZEJVdwZNpwI0
   ZM7yoMH7ld/lMulBON0MI4ayd8wFBGzMuNg9cKYXnYMHkDXL65Sv5wm3N
   4=;
X-IronPort-AV: E=Sophos;i="5.98,222,1673913600"; 
   d="scan'208";a="1107738852"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 19:42:11 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 121C781208;
        Tue, 28 Feb 2023 19:42:08 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 28 Feb 2023 19:42:07 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.6) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Tue, 28 Feb 2023 19:42:03 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <bp@alien8.de>
CC:     <dave.hansen@linux.intel.com>, <itazur@amazon.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@redhat.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <tglx@linutronix.de>, <x86@kernel.org>, <zulinx86@gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Date:   Tue, 28 Feb 2023 19:41:53 +0000
Message-ID: <20230228194153.46995-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <Y/5U3N0XfRaZ2KkX@zn.tnic>
References: <Y/5U3N0XfRaZ2KkX@zn.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.6]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Date:   Tue, 28 Feb 2023 20:24:12 +0100
From:   Borislav Petkov <bp@alien8.de>
> I'd prefer if VMMs did supply whatever they prefer to the guests
> instead. None of those bits are used in the kernel for mitigations, as
> you've realized.

It is true that the kernel does not use those bits at all, but any
codes could be run inside guests.

One of examples is the following spectre/meltdown checker scipt used as
de facto standard.
https://github.com/speed47/spectre-meltdown-checker/blob/master/spectre-meltdown-checker.sh#L2768

Best regards,
Takahiro Itazuri

