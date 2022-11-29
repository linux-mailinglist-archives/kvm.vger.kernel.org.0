Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6578163BD26
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 10:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiK2Jna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 04:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiK2Jn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 04:43:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7952ED66
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 01:43:29 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AT8BXAd004036
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=9273tg8x4EQ862ln0KE3hpRFMT9D/ufNGfi8K56bc+M=;
 b=T+QcivlsOm0D0t5j8YRqsLuLPxP6MapHmmjEvGp5I50fxelfAHGcMBcnb7PrsTsEodH3
 QGzBAZr/VJTNEYo3s6FRTMQY26R9YZ7SNJAsTlS151WYaoR8kKn+Fk5S0U9miaw68+Vx
 BJbTqencOe6hILpz3KE09dlW3bjq1k46tHcwB26hpid7jpNkzFOEMO0dWvNE6YlV8odD
 /PtzNM2R5H20iaHY4nx5/tHDfaiIdAfiiw0dvEYb62hIopH/YNmLQHZ5e0t4a+XJ7tMZ
 /8AUEeVL02c8+fqVio7+ifKCI77UVwTQpQ3KPORZFFEGKKC2rDiM6sUHwYn5N0n/a/Jm Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5ebua1pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:43:28 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AT8vRiX014412
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:43:28 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5ebua1p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 09:43:28 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AT9ZFb3011003;
        Tue, 29 Nov 2022 09:43:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3m3ae9arq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 09:43:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AT9attj1966598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 09:36:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C52D54C044;
        Tue, 29 Nov 2022 09:43:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7C724C040;
        Tue, 29 Nov 2022 09:43:22 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.9.183])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 09:43:22 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221129094142.10141-2-imbrenda@linux.ibm.com>
References: <20221129094142.10141-1-imbrenda@linux.ibm.com> <20221129094142.10141-2-imbrenda@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] lib: s390x: add PSW and PSW_CUR_MASK macros
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166971500209.19077.10554230828669303444@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Tue, 29 Nov 2022 10:43:22 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IVOLrq0MC4LNPDpgYrUtyj26rS6OydHU
X-Proofpoint-ORIG-GUID: k_HXLeG-0YPaTJaYcxXxODkpLQxSfDY9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_07,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=816 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-11-29 10:41:41)
> Since a lot of code starts new CPUs using the current PSW mask, add two
> macros to streamline the creation of generic PSWs and PSWs with the
> current program mask.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
