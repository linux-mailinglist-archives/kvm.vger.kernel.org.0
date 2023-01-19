Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2316737B8
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjASL7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjASL7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:59:44 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8F63C06
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:59:42 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JBiJfC001197
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0iKCGQtLTQztqJcQyzKKaoYjRQozAfJWkTrWeG0oM/I=;
 b=mi6BRiw7J3i7V7uYrkCV5skvUMr2Z/ddv9ENmhZXS7mhsDrB+H+JNIEw4Yh9c3jRtlvo
 f9pY38g7cA/80CTmwO7kU7P65OYnS4p3/rvHfhzKFZv2SAbZNEta95I8PRcWojndXYUP
 h6oAdzekIr8BxsGg8rvRbZ8I5RzEmx1DAiGaZVPwaXniiHRYfvP8V6y5UZjq/if5vzlv
 djRUyNAmWse7PhjnEduu1TPvHKaDlVhmNyBKBo1bZx7ieIvRsi323rdC2APXbxx42PFq
 ouncrp5qv7sdV6w2/+Aej5cuMKowAtIbMKRzWdtzQVyjRoKlZsxGZxG6LrmyZlFV48TW Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n758e89je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:59:40 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBldPQ013318
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:59:40 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n758e89j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:59:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IL08xr017303;
        Thu, 19 Jan 2023 11:59:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3n3m16cuha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:59:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBxY9550135326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:59:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D25C20049;
        Thu, 19 Jan 2023 11:59:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0739220043;
        Thu, 19 Jan 2023 11:59:34 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.91.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 19 Jan 2023 11:59:33 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 8/8] s390x/Makefile: add an extra
 `%.aux.o` target
In-Reply-To: <20230119114045.34553-9-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
 <20230119114045.34553-9-mhartmay@linux.ibm.com>
Date:   Thu, 19 Jan 2023 12:59:33 +0100
Message-ID: <87pmbavioq.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sTOWhZtU36RfoOhIywi3U5vM9mlBI2Dp
X-Proofpoint-ORIG-GUID: S9LdNEnhJmSk8d0h45Ps8oFPyjEZ4KEM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc Hartmayer <mhartmay@linux.ibm.com> writes:

> It's unusual to create multiple files in one target rule, therefore
> let's create an extra target for `%.aux.o`. As a side effect, this
> change fixes the dependency tracking of the prerequisites of `.aux.o`
> (lib/auxinfo.c wasn't listed before).
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  s390x/Makefile | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 9a8e2af1b2be..6fa62416c0e9 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -162,13 +162,14 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(sni=
ppet_lib) $(FLATLIBS) $(SNIPP
>  %.lds: %.lds.S $(asm-offsets)
>  	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
>=20=20
> +%.aux.o: $(SRCDIR)/lib/auxinfo.c
> +	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
> +
>  .SECONDEXPANSION:
> -%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $=
$(snippet-hdr-obj) %.o
> -	$(CC) $(CFLAGS) -c -o $(@:.elf=3D.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROG=
NAME=3D\"$@\"
> +%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $=
$(snippet-hdr-obj) %.o %.aux.o
>  	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
> -		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) $(@:.=
elf=3D.aux.o) || \
> +		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
>  		{ echo "Failure probably caused by missing definition of gen-se-header=
 executable"; exit 1; }
> -	$(RM) $(@:.elf=3D.aux.o)
>  	@chmod a-x $@
>=20=20
>  # Secure Execution Customer Communication Key file
> --=20
> 2.34.1
>

I don=E2=80=99t have a strong opinion about this patch, but we could either
change the ARM & Power Makefiles as well or just drop this patch.

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
