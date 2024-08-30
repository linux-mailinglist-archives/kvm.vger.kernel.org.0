Return-Path: <kvm+bounces-25433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 219EB9655A6
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D968B2837F2
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 03:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1425A13A261;
	Fri, 30 Aug 2024 03:26:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C1C567F
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 03:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.110.167.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724988369; cv=none; b=I/pMi9vp2LCaH3Al7QqZnQrqVaLojgMOH0yNdatGPDff5ZbUUuCKtITRyzLk1pgPHWwADP+Gu3vWRb+N5ULDzTBP14B6HN2QqKH5JHJpoUxZgOCQbyHQxSi+B7oHxouLQBgZ86WlwAFqGwo97Y9OiFMHCEagmMgG+vJIM+ZGE1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724988369; c=relaxed/simple;
	bh=cCybs2z3Xyhftu0poGsHh5N9fVOr+lnWh6U9HIM1L8U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sK/dt67gpVf1zEKn3eDDSnt+vP/3vepQWUyA6ZwNrtPvi8fXtP2YDQIM06mA6BgLm2wj2tn60MNZx3kT01/Xu1GBRHZ+KPSn7q09XifqPwcQomOGfQCb43meonkP1Prr4YaxuB58yioxHcgeJBzEXJJuram1j8hQ+HxPr+B3SNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=203.110.167.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1724987596-1eb14e31a8dcda0001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id nraA4FDw3jRuuGkN (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 30 Aug 2024 11:13:16 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX2.zhaoxin.com (10.28.252.164) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 30 Aug
 2024 11:13:15 +0800
Received: from ZXSHMBX2.zhaoxin.com ([fe80::d4e0:880a:d21:684d]) by
 ZXSHMBX2.zhaoxin.com ([fe80::d4e0:880a:d21:684d%4]) with mapi id
 15.01.2507.039; Fri, 30 Aug 2024 11:13:15 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from localhost.localdomain (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 30 Aug
 2024 10:58:27 +0800
From: EwanHai <ewanhai-oc@zhaoxin.com>
To: <ewanhai-oc@zhaoxin.com>
CC: <cobechen@zhaoxin.com>, <ewanhai@zhaoxin.com>, <kvm@vger.kernel.org>,
	<mtosatti@redhat.com>, <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
	<xiaoyao.li@intel.com>, <zhao1.liu@intel.com>
Subject: PING: [PATCH v3] target/i386/kvm: Refine VMX controls setting for backward compatibility
Date: Thu, 29 Aug 2024 22:58:27 -0400
X-ASG-Orig-Subj: PING: [PATCH v3] target/i386/kvm: Refine VMX controls setting for backward compatibility
Message-ID: <20240830025827.2175695-1-ewanhai-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <a8f89526-5226-4859-98ef-5342c360d7db@zhaoxin.com>
References: <a8f89526-5226-4859-98ef-5342c360d7db@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 8/30/2024 11:13:14 AM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1724987596
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 517
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.52
X-Barracuda-Spam-Status: No, SCORE=-1.52 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA_TO_FROM_ADDR_MATCH
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.129737
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_SC0_SA_TO_FROM_ADDR_MATCH Sender Address Matches Recipient
	                           Address

Dear Maintainers and Paolo,

I hope this email finds you well. This is my second follow-up regarding the
patch I submitted for review. I previously sent a reminder on July 23rd, bu=
t
I have yet to receive any updates or further comments.

I understand that you have many responsibilities, but I would greatly
appreciate any feedback or status updates on this patch. Your guidance is
essential for moving this forward.

Thank you once again for your time and attention to this matter.

Best regards,
Ewan

