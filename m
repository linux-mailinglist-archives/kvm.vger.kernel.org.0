Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDC6667D5E
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbjALSEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240203AbjALSDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093651DF30
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 09:27:28 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CG8XhB011434;
        Thu, 12 Jan 2023 17:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=vN1jvqgjM0zVGr4WeSIh964xj2hZDvl547Ay/qCWPog=;
 b=K5PHVi04ftrptb0NAHBcSN2/VUfRj0lttoZEEF9z74VXV3Thqu0xblNjJLpGiiF47c8S
 V+XNwu3eB6tCV8JcxKP2sQGv3t6VMbl5HLMuZtTaCTPsKWMZxgiz/yVa/Z7oUEVZCxOA
 acCIeqJoXaiOekG5g2We26PfpUN+x1L0/wp4nKFxkkfqeLXv37uNBS/P5e+fjL//ccUA
 wgpx2guez269LW4QVWHp5rQLX7DV8xTvypKmf6O+Tst7xEcMC4K8ziD08aW3BIWOd+GR
 7KAS9hGSfBcYC147aCLFFTb7hrqtCOM0ZbajJyEQvHBC/ZNNIgJn5EYBNYbJ1fMNyxoY fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mxwjtvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:27:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CGGNKK010086;
        Thu, 12 Jan 2023 17:27:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mxwjtv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:27:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CF2XpC004531;
        Thu, 12 Jan 2023 17:27:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n1kkytsr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:27:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CHR4Rs48562658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 17:27:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B769E20043;
        Thu, 12 Jan 2023 17:27:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E44620040;
        Thu, 12 Jan 2023 17:27:04 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.152.120])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 17:27:04 +0000 (GMT)
Message-ID: <71b5c6d559cec1eeb003ef7bc892a81da4efa613.camel@linux.ibm.com>
Subject: Re: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query
 topology information
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     "Daniel P." =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        clg@kaod.org
Date:   Thu, 12 Jan 2023 18:27:04 +0100
In-Reply-To: <Y7/4rm9JYihUpLS1@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-10-pmorel@linux.ibm.com>
         <Y7/4rm9JYihUpLS1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LgeW_IICXk1FO9v4a4v7uNHATwrjbAr6
X-Proofpoint-ORIG-GUID: XyyPblxnUwiwwbKzU3acReXT20EZG-AH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-01-12 at 12:10 +0000, Daniel P. Berrang=C3=A9 wrote

[...]
>=20
> We already have 'query-cpus-fast' wich returns one entry for
> each CPU. In fact why do we need to add query-topology at all.
> Can't we just add book-id / drawer-id / polarity / dedicated
> to the query-cpus-fast result ?

Is there an existing command for setting cpu properties, also?
>=20
> With regards,
> Daniel

