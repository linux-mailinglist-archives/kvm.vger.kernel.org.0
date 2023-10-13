Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99907C81C6
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 11:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjJMJSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 05:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjJMJSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 05:18:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C54395;
        Fri, 13 Oct 2023 02:18:30 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39D9ERmZ032594;
        Fri, 13 Oct 2023 09:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LAuOu56vhQ61V5HtfuNWXmXEsG8RHTg2aOXfBU6PuLM=;
 b=PWmJ6L1HytkNjFaBw8+KyE3QmhhON0LZpLx3/lT/fDv+N91fkiSADCnIXalxxmGifgQO
 D/qTqpixiiml5XbxKxaEjMy8vtdEW0k/Rof60OXnwAufPeXpbOwaoBOX+JDlomWcmKWy
 ZZNoplskUN/q/of1TQYR+XneOkJEbkMdHyw0lUPTcy56fsehyUfN2iWHAqzfilrUoYwg
 3PiS26XJvScCl4DgKN7PXlvtZJ3wxH8fq2A1hL+8qtrcoqkuQOVM9EMru15wD3hl9LNe
 xVi8ymiEn/QdWKHZK6sWxHa0wQp71B2F3nurhD1l3deyRg7vdU2FB+5nXhVDJ4B3Mt/D vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tq339g55c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Oct 2023 09:18:18 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39D9GXRc009097;
        Fri, 13 Oct 2023 09:18:18 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tq339g54f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Oct 2023 09:18:18 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39D8KZsv009102;
        Fri, 13 Oct 2023 09:18:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tpt57jvmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Oct 2023 09:18:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39D9IEVc47513976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 09:18:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5004C20043;
        Fri, 13 Oct 2023 09:18:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACA5820040;
        Fri, 13 Oct 2023 09:18:13 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.74.130])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 13 Oct 2023 09:18:13 +0000 (GMT)
Message-ID: <2172cf228f38150844ddf1af9e4f453238d85a29.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 4/9] s390x: topology: Don't use non
 unique message
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Date:   Fri, 13 Oct 2023 11:18:13 +0200
In-Reply-To: <169718501727.15841.5127785267238990595@t14-nrb>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
         <20231011085635.1996346-5-nsg@linux.ibm.com>
         <169718501727.15841.5127785267238990595@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DQFt8axMDffZIztpenYQEX7ufnk8LA7B
X-Proofpoint-ORIG-GUID: KLnICVFCtl92vpPcgn0bLzfA-93a0w1M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_03,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxlogscore=935 lowpriorityscore=0 phishscore=0 clxscore=1015
 mlxscore=0 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-10-13 at 10:16 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:27)
> > When we test something, i.e. do a report() we want unique messages,
> > otherwise, from the test output, it will appear as if the same test was
> > run multiple times, possible with different PASS/FAIL values.
> >=20
> > Convert some reports that don't actually test anything topology specifi=
c
> > into asserts.
> > Refine the report message for others.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> There is still the "TLE: reserved bits 0000000000000000" message which ma=
y
> be duplicate, but I think you fix that in a later patch.
>=20
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

Yes, this isn't comprehensive, the rewrite takes care of the rest.
