Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F653A2B20
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 14:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFJMKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 08:10:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58116 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230113AbhFJMKo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 08:10:44 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AC7nn3032110;
        Thu, 10 Jun 2021 12:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=R5gIkfYOSlyle2Ew7mpz5qlfjYV2KAyBhHNWTShZO74=;
 b=c43PC1hU8JRYaDrPBQY5LQocJX0187FwIjTNPnVlqQ5bku5BWN8krS4HuvKiZCUbokmV
 muRIqQPPQNJ1XifpE6yvVPR4cZssAelzDmPmx6N54MGFBqLsNvQ84xx0sqjbgro6AOjz
 SvKlI6DJsBQab3j8/cHnNGLYF2DDtuyspuevsLDtsxOkorlyPoCqAbYXLFyydNs4s6hQ
 xuXrk1xohgw31U6qpivQwHw828yjcT7aREWy+TW32Vj33Q9q5Yu3CNfXg7bd7Ee8WtvU
 Iqc3cKQU0eetW5OTxXeGeolaWgtYdIzC2sZVnDlEcKzgOumM2ywx6Nxo0GdQmQtwPc7v 3g== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3930d50c0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 12:08:44 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15AC3WW8037943;
        Thu, 10 Jun 2021 12:08:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 390k1sxmqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 12:08:42 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15AC8eve020233;
        Thu, 10 Jun 2021 12:08:40 GMT
Received: from [10.175.195.97] (/10.175.195.97)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Jun 2021 05:08:40 -0700
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: __gfn_to_hva_memslot Spectre patch for stable (Was: Re: [GIT PULL]
 KVM fixes for 5.13-rc6)
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Artemiy Margaritov <artemiy.margaritov@gmail.com>
References: <20210609000743.126676-1-pbonzini@redhat.com>
Message-ID: <341559af-911e-d85f-f966-2bbc88a72114@oracle.com>
Date:   Thu, 10 Jun 2021 14:08:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210609000743.126676-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100079
X-Proofpoint-ORIG-GUID: UCcEalI8v6TgT1kDdx1_1ueW_X78sQEW
X-Proofpoint-GUID: UCcEalI8v6TgT1kDdx1_1ueW_X78sQEW
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.06.2021 02:07, Paolo Bonzini wrote:
(..)
> Paolo Bonzini (1):
>        kvm: avoid speculation-based attacks from out-of-range memslot accesses
> 

That commit looks like something that stable kernels might benefit from, too -
any plans to submit it for stable?

Responding to the pull request since I can't find that patch posted on
a mailing list.

Thanks,
Maciej
