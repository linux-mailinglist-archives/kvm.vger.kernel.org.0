Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC27D3882
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 15:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjJWNzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 09:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjJWNzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 09:55:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3D2C2;
        Mon, 23 Oct 2023 06:55:00 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NDmPXA015890;
        Mon, 23 Oct 2023 13:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cJbwg2By3UMhLJDVKdBqmyJ5FfX444IdMU802RfnSA4=;
 b=VzmHAbxaejgr7gyIFmCorNgJntdcOZ+uuFUOfN9MU+w9T8VQTUaX7pi+fnqWuE26Kvql
 EEA885UKrdU3Y/fs5I5Rnn7zRC0aoaQWAXVHTbOPZJ/P2+pA+LjdhHGgyF0YxCESGpAt
 RVBtnxctDV5QB99Lf4ccG6CYsTF+Cz/CDEH7fH47JxndtUp8gqz8R1ufWEp4imrySkvd
 jz/JYeH311cXYczJTFMJEocRnykrHz3t7G7uSScvJBqb60iyFHBZLcTg4WgPQEd/I07M
 hRArv4wsZ/NXwrMmFV0P6LqcyS7Vmverq/k92BBFCoHR4ZFQSA3ZiANAgkYjRzjORd0g +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3twsfm9kbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Oct 2023 13:54:05 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39NDmQ6c016082;
        Mon, 23 Oct 2023 13:54:04 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3twsfm9kaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Oct 2023 13:54:04 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39NCWngn010250;
        Mon, 23 Oct 2023 13:54:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsby95q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Oct 2023 13:54:03 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39NDs1xJ12714750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 13:54:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 583192004D;
        Mon, 23 Oct 2023 13:54:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FBC120043;
        Mon, 23 Oct 2023 13:54:00 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.11.96])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Oct 2023 13:54:00 +0000 (GMT)
Message-ID: <d625c6b75a7ec5508470517b6744afbb95e22657.camel@linux.ibm.com>
Subject: Re: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add
 to include path
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date:   Mon, 23 Oct 2023 15:53:59 +0200
In-Reply-To: <20231011195740.3349631-4-oliver.upton@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
         <20231011195740.3349631-4-oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NQWui_XPNTrQ_ku4TOM8zKHuT3yfYgfR
X-Proofpoint-GUID: lkYEi09Gk5C1VfTU80ylIwFXaEls-a29
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_12,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310170001 definitions=main-2310230121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-10-11 at 19:57 +0000, Oliver Upton wrote:
> Start generating sysreg-defs.h for arm64 builds in anticipation of
> updating sysreg.h to a version that depends on it.
>=20
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index a3bb36fb3cfc..07b3f4dc1a77 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -17,6 +17,17 @@ else
>  	ARCH_DIR :=3D $(ARCH)
>  endif
>=20
> +ifeq ($(ARCH),arm64)
> +arm64_tools_dir :=3D $(top_srcdir)/tools/arch/arm64/tools/
> +GEN_HDRS :=3D $(top_srcdir)/tools/arch/arm64/include/generated/
> +CFLAGS +=3D -I$(GEN_HDRS)
> +
> +prepare:
> +	$(MAKE) -C $(arm64_tools_dir)
> +else
> +prepare:

This is a force target, all targets depending on this one will always have =
their recipe run,
so we'll pretty much rebuild everything.
Is this intentional?

> +endif
> +
>  LIBKVM +=3D lib/assert.c
>  LIBKVM +=3D lib/elf.c
>  LIBKVM +=3D lib/guest_modes.c
> @@ -256,13 +267,18 @@ $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
>  $(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $=
@
>=20
> -EXTRA_CLEAN +=3D $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) $(SPLI=
T_TESTS_OBJS) cscope.*
> +EXTRA_CLEAN +=3D $(GEN_HDRS) \
> +	       $(LIBKVM_OBJS) \
> +	       $(SPLIT_TESTS_OBJS) \
> +	       $(TEST_DEP_FILES) \
> +	       $(TEST_GEN_OBJ) \
> +	       cscope.*
>=20
>  x :=3D $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
> -$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> +$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c prepare
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>=20
> -$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
> +$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S prepare
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>=20
>  # Compile the string overrides as freestanding to prevent the compiler f=
rom
> @@ -274,6 +290,7 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>  x :=3D $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
>  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> +$(TEST_GEN_OBJ): prepare
>=20
>  cscope: include_paths =3D $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) includ=
e lib ..
>  cscope:

