Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7A3AFE38
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFVHsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:48:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhFVHsh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:48:37 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M7Y95n182007;
        Tue, 22 Jun 2021 03:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3inlT+G7TQt324HQqr9Smnn1Cc8CLfWEFzQw2GeP8L4=;
 b=Di4HD7bvQg71eLCA6REKFQYUxLA3q4TUWoK/sjS6khC2C/pp7pT11tjfq4Qacw2y7zim
 auQOxTBjzfJ0g7z7FYdhJ8mclCW13n7YpyxCwi5GQSs1aMbHcn3A/7wkXhjDuoLGi4K2
 1p9rCBcl8+4bMV5HNdzo60xyYGeYXkD+sAp4c0GTKv78t4HEyNS/LuQyUzggYKprdPCA
 Tdd/vpQ5LozCZkAgnMMIeb3Y3Sb6I7RrGWaXog44T0iTy8vqtKgwMzV9o+64MYLvXwbT
 7dGgAeWHsUXCrVOCORU/habPSvl8FuhELrrHrWDTAaM+kdVChW6wAGQSk+C2BBXQ+DUl 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bae3t6uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 03:45:34 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M7ZJ9i188881;
        Tue, 22 Jun 2021 03:45:33 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bae3t6sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 03:45:33 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M7hPH3023794;
        Tue, 22 Jun 2021 07:45:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3997uh99cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 07:45:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M7jSwE8520026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:45:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8472B4204B;
        Tue, 22 Jun 2021 07:45:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7E9442045;
        Tue, 22 Jun 2021 07:45:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 07:45:27 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     mcgrof@kernel.org
Cc:     alex.williamson@redhat.com, axboe@kernel.dk, bhelgaas@google.com,
        cohuck@redhat.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, gregkh@linuxfoundation.org,
        jannh@google.com, jeyu@kernel.org, jgg@ziepe.ca, jikos@kernel.org,
        jpoimboe@redhat.com, keescook@chromium.org, kevin.tian@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, mbenes@suse.com, minchan@kernel.org,
        mjrosato@linux.ibm.com, ngupta@vflare.org, peterz@infradead.org,
        rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com,
        tglx@linutronix.de
Subject: Re: [PATCH 1/2] pci: export pci_dev_unlock() and the respective unlock
Date:   Tue, 22 Jun 2021 09:45:27 +0200
Message-Id: <20210622074527.3486039-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210622000310.728294-1-mcgrof@kernel.org>
References: <20210622000310.728294-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tHmapKhGjdnzC2kf8X1ZsHuVbBQLQXVV
X-Proofpoint-ORIG-GUID: 3XLUL0t0HKIuQU1c_eg-wIiYVfa0QOku
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 mlxlogscore=999 bulkscore=0 impostorscore=0 mlxscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Luis, Hello Bjorn,

Interesting timing, I currently have a very similar patch lying around though
with also exporting pci_dev_lock(). I'm planning to use that for upcoming
support of automatic PCI devices recovery on s390x following the
Documentation/PCI/pci-error-recovery.rst recovery flow. There too exprting
these functions would make the code simpler to grok in my opinion. So if Bjorn
accepts this there could soon be another user, not sure if one would want to
then already export pci_dev_lock() too or wait until my patches so it's not
exported without users.

Best regards,
Niklas Schnelle
