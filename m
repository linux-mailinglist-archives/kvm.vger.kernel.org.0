Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA5C5FB165
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 13:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJKL0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 07:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJKL0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 07:26:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B72480EB5
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 04:26:08 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BBDa2M006613
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : to : from : cc : subject : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=7eVBkixn6kfi3ALPRUlDmBXPgPVEsQsgRpEMmVkMHSU=;
 b=WLvxSqFNhHPihO37hy7v8HLg7v9SFGwL9pGYTPJr2jzGsf7a9eoIaNUPSOvZgsemjKSR
 pMx2EgvmLj6XasIr8Nx522TjJw0CadB4uIOYTciIRksLWIhMm3cKnDGg52QEL0Pv3hV5
 JQFVS9LEEV0SaJw2IlPKHWg1O0vc14oKIOmWzjakxDGhYy094ssPSZco3XNO02NKH0ih
 VtmDXYPsPwl7TbsdXb1oAYCYYM65dDNNB1m5hI1jqtZwFUuAJShxzNKrnVFbW6xLjj5/
 eededr9ZJydL/0/XUJOC0n/FeUzWfaXQT5fIqH7vmuFa4x7On7Z6aGL5diH9vN8VRNov 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k544cxbn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:26:07 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29BBI778027142
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:26:06 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k544cxbma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 11:26:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BBLLH5006644;
        Tue, 11 Oct 2022 11:26:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3k30fj356u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 11:26:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BBQ1n830278124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 11:26:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8E5DAE051;
        Tue, 11 Oct 2022 11:26:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC723AE045;
        Tue, 11 Oct 2022 11:26:01 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.53.19])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 11:26:01 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20221006131856.430dfc6a@p-imbrenda>
References: <20220901150956.1075828-1-nrb@linux.ibm.com> <20221006131856.430dfc6a@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] s390x: Add exit time test
Message-ID: <166548756151.25289.16909594988559538126@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 11 Oct 2022 13:26:01 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ecxKZrUImOjONd-potQoQ7gdT02fvfRk
X-Proofpoint-GUID: gs0e-FYmKz00j6bBV_ota8SSrTMlEqI1
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_07,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio,

Quoting Claudio Imbrenda (2022-10-06 13:18:56)
> perhaps it makes sense to merge this patch series with your other one,
> "s390x: Add migration test for guest TOD clock"
>=20
> they both concern timing and reshuffling around and/or fixing timing
> functions

Since the TOD migration test is useful for regression testing my PV clock
fix[1], I would like to have this in ASAP. The exittime test, though, can w=
ait
for a bit. If it's OK for you, I would like to keep these things seperate a=
nd
rather (re-)base the exittime test on the TOD migration test.

[1] https://lore.kernel.org/all/20221005163258.117232-1-nrb@linux.ibm.com/
