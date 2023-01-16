Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E1666CEEE
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbjAPSgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbjAPSgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:36:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162A82ED53
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 10:25:35 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GGiaNP004786
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dN+TNjUuR9Ij4IbsqwS6vZo5NWn66qyGvjrjNhB49gw=;
 b=SnkViVhgKlX3F6vm+6eHwS2FNDEYNJ5tmB2SkuOhUYQ49ODNMLRn3lbdzuXKzDlVttl7
 2rdK7IxbpKP8D5o22Kj7PdHbFHT2DqGB/AO/3I7lso5Y5klmjvAVRrYCFmspHEQQa3Lb
 n3Dg/NvdaG5acSJjpiBaM4oNfjzX/b9/ld8dgoS1EgLXcI/5oSUwLNqHlbu8UjmC+aXw
 8RsM17E0U34byv8cAI152MmNRaBgSi3uzq/72M9IFuyIF1BfaEP49yank1tqEPruciXK
 FO9mE/rp2/SdhoTap7sh8uZ4+A+5p0Q0/8pqzVVqX9BW3nThSudk2rIgI2IJX3a6ypm6 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5ac3hv9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:34 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GID2XB016275
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5ac3hv92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GI5EG2001386;
        Mon, 16 Jan 2023 18:25:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16js9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GIPSed50987344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:25:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36B5D20043;
        Mon, 16 Jan 2023 18:25:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAF9320040;
        Mon, 16 Jan 2023 18:25:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 18:25:27 +0000 (GMT)
Date:   Mon, 16 Jan 2023 19:20:02 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x/Makefile: fix `*.gbin` target
 dependencies
Message-ID: <20230116192002.085f43b0@p-imbrenda>
In-Reply-To: <20230116175757.71059-4-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
        <20230116175757.71059-4-mhartmay@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7DdFMuGCNWoTuXwthkmUIoDnMFVpmB9i
X-Proofpoint-GUID: 8cHrfw_Z2dnpglk71VutAQuUDyHr_fFF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301160135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Jan 2023 18:57:51 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> If the linker scripts change, then the .gbin binaries must be rebuilt.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

I think this should be merged into the previous patch

> ---
>  s390x/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 660ff06f1e7c..b6bf2ed99afd 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -135,12 +135,12 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
>  $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>  
> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SRCDIR)/s390x/snippets/asm/flat.lds
>  	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $<
>  	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>  	truncate -s '%4096' $@
>  
> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SRCDIR)/s390x/snippets/c/flat.lds
>  	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
>  	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>  	truncate -s '%4096' $@

