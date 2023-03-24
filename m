Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2066C6C7E30
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjCXMkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjCXMkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:40:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F51B5FD2
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:40:02 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OAZXNR023278
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=X2l4ZlBNNw6iF79oH5Rcy4F4aE1pn3N/gNuysm6CBGM=;
 b=KJXwWiB1dg5h0l1WakyO5tUBTjf4lROZjpLptNivNwRCJxNnFpDlWuQp+wX8cMNfTXIO
 S2NFNq2IqWLjPJb/p506uVup/jRECwCnoDlo+c2fALRAvSZwiBS2RapfsGNF7q2EfdO9
 b5DYzQkU2CmUGeZlqy4Id9T7Wo5YbUX5NshrQ9yK9rD5gIm1xos+4c2CJjhNfBVqyQ0s
 nMJaACM2+fHwsYy6Ou+jU/T/JvOmsBZlHlKCRHsp+iInQrG722j0YiTBT6FEm12boLbr
 DHetUeAnUT2GAaBl2BOVO5XBpCZaJz6bSxDvNPxT9AorplUiE9vknHdAP82qglk9dG/1 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b2tj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:39:54 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBrWxf005182
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:39:54 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b2ths-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:39:54 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLdGUB016682;
        Fri, 24 Mar 2023 12:39:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pgxv8gpqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:39:52 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCdm0832243974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:39:49 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D688620043;
        Fri, 24 Mar 2023 12:39:48 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B336C2004D;
        Fri, 24 Mar 2023 12:39:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:39:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230324121724.1627-2-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com> <20230324121724.1627-2-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/9] s390x: uv-host: Fix UV init test memory allocation
Message-ID: <167966158830.41638.170427129071965942@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 13:39:48 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: inewZyaXE1c6uzHL8cvW1R2MuYfKcd_P
X-Proofpoint-GUID: HXvJQeWD2TE18iZ0w_3EKkw_RUYBCatn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240102
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-24 13:17:16)
> The init memory has to be above 2G and 1M aligned but we're currently
> aligning on 2G which means the allocations need a lot of unused
> memory.
>=20
> Also the second block of memory was never actually used for the double
> init test since its address is never put into the uvcb.
>=20
> Let's fix that.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
