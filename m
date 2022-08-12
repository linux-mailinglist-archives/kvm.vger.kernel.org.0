Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFAD59111C
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbiHLM4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 08:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiHLM4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 08:56:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9EB79A4E;
        Fri, 12 Aug 2022 05:56:30 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27CCsC7b006372;
        Fri, 12 Aug 2022 12:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=1WqgJg/FgiFiiI1bZQ4VmnuST/oM+/8DKFwoXkyCzMs=;
 b=dUpUcio7q0Y79if/XQ1RY/Q9R14WXAoAtBZuCJVeD0/FCgz56wtibPwsrHWdGJvAePka
 BzRy4TZUVuhygYV465anOjUoTdyifP2Ls+B5b/yZpLb1kNvjh/TM5zZsgdjkHO8vz4hl
 ZRHrry++ozPoOuV9nLDe9KkHKgmt6u/2VFJY6OzKNBIxXYlf4+r8pU+Z8o/Z4IM8WOSR
 YJ3fckaYsZ0KA/gCkpJ3YqWUlk9+1D5tfO3tdgIwztrhW6CSme5oKSsOSJ9VJbMFZxdZ
 YLuljzDLduiZHehWqUKCKVy+AojrN2vlYV3fBeE2h6PFHizUHrA9YBiqFoANWajq+sIS wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwq9c81xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 12:56:30 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27CCsp2x009910;
        Fri, 12 Aug 2022 12:56:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwq9c81ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 12:56:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27CCpsI6016436;
        Fri, 12 Aug 2022 12:56:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3hw4nxrr7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 12:56:26 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27CCufnU33358140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 12:56:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7772AE055;
        Fri, 12 Aug 2022 12:56:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B881FAE053;
        Fri, 12 Aug 2022 12:56:23 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.40.207])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 12:56:23 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220810125625.45295-6-imbrenda@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com> <20220810125625.45295-6-imbrenda@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v13 5/6] KVM: s390: pv: support for Destroy fast UVC
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com
Message-ID: <166030898350.24812.8013075066735672338@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 12 Aug 2022 14:56:23 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: agHQOIR3QB2wW_PElCWEv8uwOflwiri4
X-Proofpoint-GUID: LJp77FCU931-bo-5pL8ZFcBvbFZJU9Fk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_08,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=916 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-10 14:56:24)
> Add support for the Destroy Secure Configuration Fast Ultravisor call,
> and take advantage of it for asynchronous destroy.
>=20
> When supported, the protected guest is destroyed immediately using the
> new UVC, leaving only the memory to be cleaned up asynchronously.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
