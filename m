Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B0636C82D
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbhD0PBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:01:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236710AbhD0PBO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 11:01:14 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13REX77C150032;
        Tue, 27 Apr 2021 10:59:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+QlamBl19HO/Z+/EikQ6Mdam0domaFKqNPPFu7gdiHg=;
 b=Fla/1GQ052qfVp80lcNJgB52juyMtdxf7DoNbSbDGYfCt9Mg9l/a/Z9B+a4cY7Sul7CA
 ywlQZ9nrkkSAK+XSb8tbw/p7RnOL6sUgeyr1DBD1Y6SnfzTrjsv7vEa0URi3DNpAGc/p
 NltUxHwIBw/LICmCEBs2aEuQ5XG6/Iz0UoHooNpQOGkTarbLq6E8jmOwzilJBBVi+oCG
 YS4cmxFmMf89tVLL/RjjK+Ec98cudUkRrRbMmK0/42WJzNraGW5G6jQgr+zZt6rRK888
 +SRzzep2ZpNQY0TQ8F8xO3r2V1vBUChMLj0COjjpczYI0cZA3aq+RYa8cQKf4td13BdJ SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386cf38bj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 10:59:32 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13REYJGJ154559;
        Tue, 27 Apr 2021 10:59:32 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386cf38bh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 10:59:32 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13REw7Od006549;
        Tue, 27 Apr 2021 14:59:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 384gjxrr9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 14:59:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13REx1YU34668996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 14:59:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21F1A11C050;
        Tue, 27 Apr 2021 14:59:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DEC711C04C;
        Tue, 27 Apr 2021 14:59:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 27 Apr 2021 14:59:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C0F6CE028D; Tue, 27 Apr 2021 16:59:25 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     peterz@infradead.org
Cc:     bristot@redhat.com, bsegall@google.com, dietmar.eggemann@arm.com,
        greg@kroah.com, gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
Date:   Tue, 27 Apr 2021 16:59:25 +0200
Message-Id: <20210427145925.5246-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412102001.287610138@infradead.org>
References: <20210412102001.287610138@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eKX2-Ma5Wve74Wy6SnaoNJ_DMaO9FzIX
X-Proofpoint-ORIG-GUID: oKwvlBcQkWFx-YEwG_gOPg9dEDJ3vNAT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_08:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=823 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1011
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104270105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter,

I just realized that we moved away sysctl tunabled to debugfs in next.
We have seen several cases where it was benefitial to set
sched_migration_cost_ns to a lower value. For example with KVM I can
easily get 50% more transactions with 50000 instead of 500000. 
Until now it was possible to use tuned or /etc/sysctl.conf to set
these things permanently. 

Given that some people do not want to have debugfs mounted all the time
I would consider this a regression. The sysctl tunable was always 
available.

I am ok with the "informational" things being in debugfs, but not
the tunables. So how do we proceed here?

Christian
