Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9496B1472
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 22:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCHVrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 16:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCHVqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 16:46:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CE059809
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 13:46:30 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328KViTj007249
        for <kvm@vger.kernel.org>; Wed, 8 Mar 2023 21:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=60M3Iqg/CHx6u83ZmS5Y+tmWwPck8YBkxDhRrMN4WXE=;
 b=A3iJNoqMWnKtmYlZfO8DRwyh02h3/KAnMC7DnjkxqVyTdCnuEoA2GnPzjCWgxWYw0uul
 Fx6aaP18uKbALWsvVPWGHdeQumJidFSDB2fctYvwN3KPCmN5ryQhj8Wk9bl7d3myhvGb
 +4Q8Wdpaay/QIyOdxBR4eOabFFvEmfVNpY3zcKDXokBUz5anT9unhpT20opewH1IBhAE
 f+efsDJt1toe/xjQfXI0z1HEnxXtCCHle0T6Y09GL7sppX2dUOhPFVpEGSULxGWMpwHL
 bJTtI6A+OCVvkd6FG17dIZ0jzJX8CHRlsWvftF1NHThmQxB5ExlKRfJgh5HaWG3V/WwJ xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6s9afkcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 21:46:30 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 328LbRNc014900
        for <kvm@vger.kernel.org>; Wed, 8 Mar 2023 21:46:29 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6s9afkbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 21:46:29 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 328IJs5t015019;
        Wed, 8 Mar 2023 21:46:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3p6gbw90te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 21:46:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328LkNV465798504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 21:46:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E9302004F;
        Wed,  8 Mar 2023 21:46:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EB1F20040;
        Wed,  8 Mar 2023 21:46:23 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.174.72])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Mar 2023 21:46:22 +0000 (GMT)
Message-ID: <8eed60ee20e370a8d0784340d802e498e5542c77.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/7] s390x: define a macro for the
 stack frame size
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Date:   Wed, 08 Mar 2023 22:46:22 +0100
In-Reply-To: <20230307091051.13945-7-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
         <20230307091051.13945-7-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a5irvRBVXWs1X48fzh3GvB6j1xfP3j2m
X-Proofpoint-GUID: OHWouHEhCj_KCgTXKLflLut8g5Ept5fo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> Define and use a macro for the stack frame size. While at it, fix
> whitespace in the `gs_handler_asm` block.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Co-developed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

[...]
