Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A047E666188
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbjAKRPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbjAKRPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:15:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0381513F86
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 09:15:20 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BGUgqW032273;
        Wed, 11 Jan 2023 17:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=9sxcrTQdD4oH23FESbyUcgXBPeiJ+qNe4My9X6jF0ls=;
 b=DOAEJ/+whbk7XVtVmqz7asnLkcD6jgPHorwkY+/sLbXsZpxyyRO8djDAWrWi1TUs3fsp
 kXvhwPoCHivHEU7ZEhC+hTGskaTFS93KDuy+aY18owfmDLPVjwVCqkW3IPg9EuHnZYQi
 K7Ygw7jOLOAVpBjxpOtqLchuQh2DCdylJxaE9xbQaEmWuEyh1Z8dxhrsftCdc7Efn06X
 fabJC8W22x4tikdzBDcVpv/3jVoOT0QauLS4P0kvBUM4f42R/eGEUnkIwfe8iSQZfDPT
 SchtTdTFezLeuvqc70ELRyIfdsBU602GpfD6AKTnlQEt64CZQNb6V+EgYZp6yqei97mf Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n20pv1dt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 17:15:05 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30BGVipS003953;
        Wed, 11 Jan 2023 17:15:05 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n20pv1ds1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 17:15:04 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30BGp7l5003295;
        Wed, 11 Jan 2023 17:15:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n1kmtgvy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 17:15:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30BHEwSn45679096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 17:14:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E9A920040;
        Wed, 11 Jan 2023 17:14:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C68220043;
        Wed, 11 Jan 2023 17:14:58 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.175.58])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Jan 2023 17:14:58 +0000 (GMT)
Message-ID: <cf0ce650d86e9a1fae7477d1ed8e49d87fc4d9d2.camel@linux.ibm.com>
Subject: Re: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15)
 and build the SYSIB
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 11 Jan 2023 18:14:58 +0100
In-Reply-To: <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-4-pmorel@linux.ibm.com>
         <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2RPftDXXClV8p8RsqWFBIY13IFxYhvlA
X-Proofpoint-GUID: zcRf8ooUXzQAH50TiRAVlWbAM0N0D9SR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_07,2023-01-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=806 mlxscore=0 phishscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-01-10 at 15:29 +0100, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
> > On interception of STSI(15.1.x) the System Information Block
> > (SYSIB) is built from the list of pre-ordered topology entries.
> >=20
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
>=20
[...]

> > +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar=
)
> > +{
> > +    union {
> > +        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
> > +        SysIB_151x sysib;
> > +    } buffer QEMU_ALIGNED(8) =3D {};
> > +    int len;
> > +
> > +    if (!s390_has_topology() || sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_=
MNEST) {
> > +        setcc(cpu, 3);
> > +        return;
> > +    }
> > +
> > +    len =3D setup_stsi(cpu, &buffer.sysib, sel2);
> > +
> > +    if (len > 4096) {
>=20
> Maybe use TARGET_PAGE_SIZE instead of 4096 ?

sizeof(SysIB) would be preferable IMO.
>=20
> > +        setcc(cpu, 3);
> > +        return;
> > +    }
