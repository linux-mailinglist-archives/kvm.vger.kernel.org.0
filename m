Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD5C5593D2
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 08:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiFXG6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 02:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiFXG6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 02:58:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD0C233;
        Thu, 23 Jun 2022 23:57:53 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25O6Dqij039822;
        Fri, 24 Jun 2022 06:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=ZOkWcd3P/zDX/fKtBJcx0GUV33m8zdRhwp+2GKVmW4Y=;
 b=q3dzrytvg/HR8ufVRjWNAgA55Vxoe8PmyycK3Y8jBXVw6cXEZfVOINXbS0+SV3z15McZ
 Kj/2Ry3puYoLhdLtx2PLpvECB5ndDQo6RJhtJLINu3515uOy/blZ9J/mkF4neFeq/XoH
 xYqurLw3s/5W5jEgbZUH4blmhAMRIGt8djj93OXVJr1a1D8DrzsP4dojW1TouA4PqfrB
 dh/p0iDA5J/4PHmPQB3wvOkFPC+8BOS/AxXgsJOBgJFEKBeZz+hHn+e5bxUfyC9gKnaG
 GmjJ9fWqluUkHh/aRvUXkVO+eGsCiee01XMnsMIHSlUnHJvgoIUgHIoqdX5hqBExds0K Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw7tgh1cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:57:52 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25O6MFBR029496;
        Fri, 24 Jun 2022 06:57:51 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw7tgh1bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:57:51 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25O6p1VY018667;
        Fri, 24 Jun 2022 06:57:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gvuj7rw84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:57:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25O6vk2x15663360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 06:57:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A95BFA4040;
        Fri, 24 Jun 2022 06:57:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BDC0A4053;
        Fri, 24 Jun 2022 06:57:46 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.95.53])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 06:57:46 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220620125437.37122-2-pmorel@linux.ibm.com>
References: <20220620125437.37122-1-pmorel@linux.ibm.com> <20220620125437.37122-2-pmorel@linux.ibm.com>
Subject: Re: [PATCH v10 1/3] KVM: s390: ipte lock for SCA access should be contained in KVM
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <165605386635.8840.16705488876454527148@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 24 Jun 2022 08:57:46 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iwjZuO9ZdYlIA8yS7oLhWObprYRD7f3W
X-Proofpoint-GUID: 4DJm1WFd1BiNFHqyRgOPEBt2db1ooMgH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_04,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015 mlxlogscore=972
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240023
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2022-06-20 14:54:35)
> We can check if SIIF is enabled by testing the sclp_info struct
> instead of testing the sie control block eca variable.
> sclp.has_ssif is the only requirement to set ECA_SII anyway
> so we can go straight to the source for that.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
