Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638166B13E4
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 22:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCHVca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 16:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjCHVc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 16:32:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12E3D291A
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 13:32:22 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328KMwKN027954
        for <kvm@vger.kernel.org>; Wed, 8 Mar 2023 21:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Bz7VXGEkE6jW3mJlqpg95WAOKP97o5E1AwMvyEtlYXc=;
 b=j00Bu1HlWysSEBLdSItiH9xQkeOESJHMy3netReS2nCuwG6x+/4iKjzGYB13hkv1acxw
 6oT52C7gL1gv0zZFd9bjM/RD/GzirrFpxT3s4UqzwrMsQ3slBkLOEyFD9RHQwmcts0MR
 OnQcpt/0lpSOWMinQ4GjjMSBSbQhDerHz5k6uV64l7abgzLo3zGdBiYSl04t8zt6C/hy
 SfaanpMpDVeNAHF1YEp2xcMZlaO5o14KWhoku8R5FA9fMT70WpALqjLi8iWdVO4odgfB
 bvcpXN7Vl0SJqj6vbP0MZ2AUxSYwkWmNleNVwsenlChqhxA03CxcmT+Wep8QLcf6BBNJ +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6sdff30v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 21:32:22 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 328LUGoq013729
        for <kvm@vger.kernel.org>; Wed, 8 Mar 2023 21:32:22 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6sdff308-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 21:32:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 328DZxH8020036;
        Wed, 8 Mar 2023 21:32:19 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3p6ftvhd4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 21:32:19 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328LWG6k29819476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 21:32:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1598820043;
        Wed,  8 Mar 2023 21:32:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1EF220040;
        Wed,  8 Mar 2023 21:32:15 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.174.72])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Mar 2023 21:32:15 +0000 (GMT)
Message-ID: <ab5344a72e65e0db35c9716f1679b82126d43d54.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: use preprocessor for
 linker script generation
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Date:   Wed, 08 Mar 2023 22:32:15 +0100
In-Reply-To: <20230307091051.13945-6-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
         <20230307091051.13945-6-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3cDx8pR3iR0liKG7HqSzS9mayT20Q7IJ
X-Proofpoint-ORIG-GUID: ujrDCGh67rve6LjiP_AApQumQpJjrNxF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=788 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080182
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-03-07 at 10:10 +0100, Marc Hartmayer wrote:
> The old `.lds` scripts are being renamed to `.lds.S` and the actual
> `.lds` scripts are being generated by the assembler preprocessor. This
> change allows us to use constants defined by macros in the `.lds.S`
> files.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

[...]
