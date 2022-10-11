Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B64A5FB1C9
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 13:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJKLqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 07:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiJKLp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 07:45:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C96F8E9AD
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 04:45:03 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BB1gs5012630
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:44:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=MC2NFDYH92m+a8FgQG4lY348uLdOMAjT9c+JJRazefg=;
 b=rnbYIZ+sz/c+KSCeDx8JpJg6XTAyHa7z5Y3T+TancYjDIlHpsQbtgvFJKRdhFhQsCJzS
 W8U61/vp1Clv9T+fKIGPXE8+PvITII9HUZYj7qxSUk2Eo7OaRQNZ4EUSO2JMvs1TI/Dh
 uRLtctpd0bAJKYi27eMgkVInw6nwBJK2FpssfpkUfySUGl1CinCUCWMIbwIU0KPHzi1S
 UN00OoWSvlptaIJ8JDSYIcQVlDtSMwA1pDEhM1+96PvKl++cLmcZs6vejeGfPextfR+Y
 TdBWZyOhIIjdz6RHYDjatt4MlNacdqgbBe84Gn8uyLC8V08ETRUJ+sa+9UpGEmKzU/r4 VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k578mh41b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:44:40 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29BBKS1v007827
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:44:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k578mh40e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 11:44:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BBYl64023972;
        Tue, 11 Oct 2022 11:44:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u94877-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 11:44:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BBiYYb50725126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 11:44:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1A9CA404D;
        Tue, 11 Oct 2022 11:44:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D52C3A4040;
        Tue, 11 Oct 2022 11:44:33 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.53.19])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 11:44:33 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221006125014.0df15a8b@p-imbrenda>
References: <20220826084944.19466-1-nrb@linux.ibm.com> <20220826084944.19466-2-nrb@linux.ibm.com> <20221006125014.0df15a8b@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib/s390x: move TOD clock related functions to library
Message-ID: <166548867366.25289.14500269912603629847@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 11 Oct 2022 13:44:33 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZKTEy_DA-20FNms0EYTk-kRir4DXiG7O
X-Proofpoint-ORIG-GUID: Oe1VEhmiEzChPRyR3Cxx1gmurCPY0vek
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_07,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-10-06 12:50:14)
[...]
> > diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> > index 7652a151e87a..81b57e2b4894 100644
[...]
> > +static inline int sck(uint64_t *time)
[...]
> > +static inline int stck(uint64_t *time)
[...]
> > +static inline int stckf(uint64_t *time)
[...]
>=20
> please put these functions before all the other inline functions, and
> then fix get_clock_us to use the wrapper instead of the (broken) inline
> asm

Yes, this makes sense, thanks.
