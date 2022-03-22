Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4016E4E3F6F
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbiCVNYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiCVNYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:24:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502927E5BE;
        Tue, 22 Mar 2022 06:22:47 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MCb31f014297;
        Tue, 22 Mar 2022 13:22:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=tw8bVrBgwefDDmwqf4somrVpja5sbtoTlbXKwHJzlZ4=;
 b=nMWDY4q5r5kUnSPEouNR3EBDgHmqtFRzLSKcij4eBPuHTe0KqiMuJwDrKntxXJct/L+B
 r7qLI13jD7+WVdrNnmppDli6P7n4cKHjTsd8M4TPU/6IJFpj4Mnfd6f7ymcry4v1Wwd3
 7G8E1TQ7ZTpwVOJARb1Wlw6oEaYr9YPI9afHWOxhvq90Vid3iE/UC8KNS9y5y58v1TTb
 7AhpwpmWjb1jdtlg84GA8qGZGyzTaIgRB4g8H7V1H3HrOXtj0PYOAFYywSYd44HPjk1d
 DIVhcLHZbzSXn+YSvwhONTswSvzmi8O0nJGMU/UwOI3kRbXaJaSDGSRjOVAx9tNQ7nXD HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey7abjc06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:22:45 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MDI8sF001494;
        Tue, 22 Mar 2022 13:22:44 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey7abjbyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:22:44 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MDHFT9027266;
        Tue, 22 Mar 2022 13:22:43 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3ew6t9s9n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:22:43 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MDMg8Y31129886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 13:22:42 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38C87C6063;
        Tue, 22 Mar 2022 13:22:42 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19360C6066;
        Tue, 22 Mar 2022 13:22:41 +0000 (GMT)
Received: from [9.160.96.60] (unknown [9.160.96.60])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 13:22:40 +0000 (GMT)
Message-ID: <d66ef5e1-9a77-a71c-e182-ca1f3fc17574@linux.ibm.com>
Date:   Tue, 22 Mar 2022 09:22:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 14/18] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-15-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220215005040.52697-15-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PwHVyogRqCvjBDe2H8WqKvNirNarm52n
X-Proofpoint-ORIG-GUID: 7m59dUStEGwCfYmlfumtebxFfpnO3e_x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 19:50, Tony Krowiak wrote:
> The matrix of adapters and domains configured in a guest's APCB may
> differ from the matrix of adapters and domains assigned to the matrix mdev,
> so this patch introduces a sysfs attribute to display the matrix of
> adapters and domains that are or will be assigned to the APCB of a guest
> that is or will be using the matrix mdev. For a matrix mdev denoted by
> $uuid, the guest matrix can be displayed as follows:
> 
>     cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
My OCD wants you to name this matrix_guest instead of guest_matrix. Simply
because then "matrix" and "matrix_guest" will be grouped together when doing
an ls on the parent directory. As a system admin, its the little things that
make the difference :) Please consider... though I won't withhold an R-b for
it.

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
