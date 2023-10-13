Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE9B7C7B90
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 04:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjJMCVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 22:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjJMCVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 22:21:36 -0400
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2676B7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 19:21:32 -0700 (PDT)
X-ASG-Debug-ID: 1697163673-1eb14e7511561a0001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id JNyiZCaVetOnJnL2 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 13 Oct 2023 10:21:13 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 13 Oct
 2023 10:21:12 +0800
Received: from ewan-server.zhaoxin.com (10.28.66.55) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 13 Oct
 2023 10:21:11 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
From:   EwanHai <ewanhai-oc@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.163
To:     <ewanhai-oc@zhaoxin.com>
CC:     <kvm@vger.kernel.org>, <mtosatti@redhat.com>,
        <pbonzini@redhat.com>, <ewanhai@zhaoxin.com>,
        <cobechen@zhaoxin.com>, <qemu-devel@nongnu.org>
Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for backward 
Date:   Thu, 12 Oct 2023 22:21:11 -0400
X-ASG-Orig-Subj: [PATCH] target/i386/kvm: Refine VMX controls setting for backward 
Message-ID: <20231013022111.224467-1-ewanhai-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
References: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.28.66.55]
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1697163673
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 775
X-Barracuda-BRTS-Status: 0
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.52
X-Barracuda-Spam-Status: No, SCORE=-1.52 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA_TO_FROM_ADDR_MATCH
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.115324
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.50 BSF_SC0_SA_TO_FROM_ADDR_MATCH Sender Address Matches Recipient
                                   Address
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Pbonzini and QEMU community,

I submitted a patch titled "target/i386/kvm: Refine VMX controls setting for 
backward compatibility" on the 25th of September 2023. I noticed that it 
hasn't received any replies yet. Here's a link to the patch on lore.kernel.org: 
https://lore.kernel.org/all/20230925071453.14908-1-ewanhai-oc@zhaoxin.com/.

I've double-checked to ensure I CC'd the relevant maintainers and addressed 
previous review comments, if any. I understand that everyone is busy and some 
patches might get overlooked, especially in less-maintained areas.

I kindly request feedback or a review for my submission. If there are any 
issues or changes needed, please let me know.

Thank you for your time and consideration.

Best regards,
Ewan

