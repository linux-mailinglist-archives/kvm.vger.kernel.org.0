Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0CC6C68F5
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjCWM4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjCWM4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:56:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C69E2C648
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:56:03 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NBJO7q037269
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=VzcJgTjqXfLDgQYlRTm8AtJnHI0NDwrviutUD6MaBz8=;
 b=IZa7msNO+WbTev7Ern12zmtejNhmmiLrzEHXkIUb6caOckwWhhfot7I81e1Fr8nCyXA6
 7wujecXeTsbfholmhzSFsP7he6DKRZ3Qq7QVVIMBrwKiLuZR+SgaO1iI5VO1Z3IeuxBd
 gN4Uip9gal3ckhz5ZRfI96BQqWjw342n1BE8XqeF+ab7Bb3Eh9elfRSwfMgN2pxJalEx
 A1pBBIwRmHKWSXqaVOgKRxseyBEw7+ThgIgIgpg1lENJRZLywsl7FNwF8BPjZTStspkQ
 +HIKF3SOhlav6w5OdZwgRplJcSsagTrFcJfYcTJSbMb9uFsecIY6EetGRo7vjdrXvOlh gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pggv7hkqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:56:03 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NBdMVu007404
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:56:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pggv7hkq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:56:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32N0bG2d026836;
        Thu, 23 Mar 2023 12:56:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6e6eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:56:00 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NCtvgp22872806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 12:55:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13F1020040;
        Thu, 23 Mar 2023 12:55:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8F3320043;
        Thu, 23 Mar 2023 12:55:56 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.6.128])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 12:55:56 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230323103913.40720-6-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com> <20230323103913.40720-6-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/8] s390x: uv-host: Add cpu number check
Message-ID: <167957615667.13757.5715474939447071974@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 23 Mar 2023 13:55:56 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 57o3CM-pEGTOvI93xzd4SFnBmv0jU1py
X-Proofpoint-GUID: PK3f_P6m46EMtiCIC1gLQraPOF_sBK8l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-23 11:39:10)
> We should only run a test that needs more than one cpu if a sufficient
> number of cpus are available.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
