Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617D343B196
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 13:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhJZLzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 07:55:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234077AbhJZLzt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 07:55:49 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QBcb1e009523;
        Tue, 26 Oct 2021 11:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=s2NwZNz+Be8h9xEhhVLXamdujVyFAWdzG+oq0Ac6Mm0=;
 b=q07/IsbwiF4jvKcB9fIWqn3EEuvCurfwmu/9UOMKLs64MWttXOtv5q53BRh2Y0aZeDD3
 TbclORl39fHB9tqoOZ5TFH/M2re3TdgrIx5GHIedR6LJWDrVFxeGF81Asgiw4MNxZRXm
 eQ23VlTKiRKRm4OQABjvxfUsMtDT+QDf9SD/neknKW+Iye6jVNINfxjJmYUpTbMsFoyd
 iNT/9Rewc8sn0nC8RHWNbU5A85vZfY7m3vYfd2xOIFGq4l6rGgAYQsQzWAhw+y49jpKV
 49jPXKXsJSy29wJaiSoRwmEzAzPKnaPXyLK7hqL/7BA91fTdkj5fuXy4gCzuZErqnLJt Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bx5exad1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 11:53:25 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19QBofHQ025661;
        Tue, 26 Oct 2021 11:53:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bx5exad0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 11:53:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19QBqt51027180;
        Tue, 26 Oct 2021 11:53:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3bx4f151w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 11:53:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19QBrIQv62390592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 11:53:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0EEC42041;
        Tue, 26 Oct 2021 11:53:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 705974204B;
        Tue, 26 Oct 2021 11:53:17 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.51.215])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Oct 2021 11:53:17 +0000 (GMT)
Subject: Re: [PATCH v5 06/14] KVM: s390: pv: properly handle page flags for
 protected guests
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-7-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <388a092a-8810-9f67-d314-fc5c93707998@de.ibm.com>
Date:   Tue, 26 Oct 2021 13:53:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210920132502.36111-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZpVw3rXPKSSy0BpXVtidUM-m9OxQDTKb
X-Proofpoint-ORIG-GUID: qBb9q77N6bG2IBvE2bOMvBLpC3tqjEVa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=814 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 20.09.21 um 15:24 schrieb Claudio Imbrenda:
> Introduce variants of the convert and destroy page functions that also
> clear the PG_arch_1 bit used to mark them as secure pages.
> 
> The PG_arch_1 flag is always allowed to overindicate; using the new
> functions introduced here allows to reduce the extent of overindication
> and thus improve performance.
> 
> These new functions can only be called on pages for which a reference
> is already being held.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

applied.
