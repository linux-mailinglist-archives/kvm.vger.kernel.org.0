Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D82F58CB54
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 17:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbiHHPfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 11:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiHHPfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 11:35:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E941D8
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 08:35:11 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278EhcvO010649
        for <kvm@vger.kernel.org>; Mon, 8 Aug 2022 15:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=SLnkxhjH3YEIj0mMQyDV92oOuLh83a90jRYcf39Ewpg=;
 b=f/mLpZyClmWHmQQs6hUnsR6bjqZGiX7VFME7ZAbH5PgmbKllFPFjVwKJeSlVVLs4/9wo
 cVUK658NbUVyys/ID/SdX9ND5NY6mj8g8cmUL3e09Imxhh7E5WznFAnU430QofXiZMx5
 pxlTZQPzMIvrto2Du5V5SoN7zIV4AMkUCv7FDFGgasX3mCfQllxmfXUq8PF2bA07+pMD
 0HkOeli+/EtKy7/fKdkq4UrqNwikXVmZ8RPR3VY3WMP6XZxWjE2DPt7wX04IsaKtfoa5
 ScMl6nmaGWZg83Rg3Ag/x1y7flpgO0TGnzsn2cQJbv4rw9vKG6kJ91Elw3zYMkIil2FH /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hu4gdhsjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 15:35:10 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 278EiCGW012246
        for <kvm@vger.kernel.org>; Mon, 8 Aug 2022 15:35:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hu4gdhsj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Aug 2022 15:35:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 278FK8Vw005698;
        Mon, 8 Aug 2022 15:35:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3hsfx8ssde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Aug 2022 15:35:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 278FZ4ID17433000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Aug 2022 15:35:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DABC0A4054;
        Mon,  8 Aug 2022 15:35:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFC3DA405C;
        Mon,  8 Aug 2022 15:35:04 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.67.147])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Aug 2022 15:35:04 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220802180605.2b546603@p-imbrenda>
References: <20220725155420.2009109-1-nrb@linux.ibm.com> <20220725155420.2009109-4-nrb@linux.ibm.com> <20220802180605.2b546603@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: smp: add tests for calls in wait state
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <165997290456.24812.10898048641766802245@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Mon, 08 Aug 2022 17:35:04 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hF7eJggEL7D8u6E0Ay59cPRWhu2yy3iz
X-Proofpoint-ORIG-GUID: jRPLD-keRP5QSBnveDgX9BU0WHDMYTrk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_10,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 mlxlogscore=814 clxscore=1015 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-02 18:06:05)
[...]
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index 12c40cadaed2..d59ca38e7a37 100644
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c
[...]
> > +static void test_calls_in_wait(void)
> > +{
[...]
> > +             /*
> > +              * To avoid races, we need to know that the secondary CPU=
 has entered wait,
> > +              * but the architecture provides no way to check whether =
the secondary CPU
> > +              * is in wait.
> > +              *
> > +              * But since a waiting CPU is considered operating, simpl=
y stop the CPU, set
> > +              * up the restart new PSW mask in wait, send the restart =
interrupt and then
> > +              * wait until the CPU becomes operating (done by smp_cpu_=
start).
> > +              */
> > +             smp_cpu_stop(1);
> > +             expect_ext_int();
>=20
> which external interrupt are you expecting on this CPU?

Right, leftover code, can be removed. Will be fixed.
