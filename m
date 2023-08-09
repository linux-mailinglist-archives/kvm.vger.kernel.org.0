Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC0F77572F
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjHIKid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 06:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjHIKic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 06:38:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3239E10F4;
        Wed,  9 Aug 2023 03:38:32 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379AUl3N017968;
        Wed, 9 Aug 2023 10:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ezvrhQlNkMb8OG0Pm7rGSbkegXxqPmZE7j6Esr2RYKk=;
 b=GMpv0nkYfhxiec12+6oboMLYZ2yvAqHLcZxP7pI4e2WEGyk+ciEcQIUjbP6+5v+mr9f+
 fgFcheh/z9JDPmaeL/fTIiV1QD4W6fAk5Kx332hYYhNBGeHk/t4ALz/xBoz0vzEk9OMG
 kbNYrj8K+fAnRGtziK1U3k2HYWC3DvrJvUdGVoMnFYItkzuUhOzhcGiV8djDX7AU/+hv
 IRsUvFzaDmbp4fpNmhoTzJXP7O+SE0fxZfzOlJMDubhB6Rcz80QHnYwuWK77ysRR6I5X
 7hPQ1ZmlQ52GeBTpWrV67FjToWzyMHKpU7iQ3f72TbAh3FZfHzNhbj1OMkjX2UV55+ZX og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc93w07h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 10:38:30 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 379AXMfq030151;
        Wed, 9 Aug 2023 10:38:30 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc93w07f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 10:38:30 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 379A1Rvn015377;
        Wed, 9 Aug 2023 10:38:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sb3f30xff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 10:38:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 379AcOIv21365438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Aug 2023 10:38:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B38B2004E;
        Wed,  9 Aug 2023 10:38:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C61F20040;
        Wed,  9 Aug 2023 10:38:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  9 Aug 2023 10:38:24 +0000 (GMT)
Date:   Wed, 9 Aug 2023 12:38:22 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: explicitly mark stack as not
 executable
Message-ID: <20230809123822.42475ce7@p-imbrenda>
In-Reply-To: <20230809091717.1549-1-nrb@linux.ibm.com>
References: <20230809091717.1549-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0c91gZzaWUooOP47s55oqzAkmHK0jtcB
X-Proofpoint-ORIG-GUID: COJGL4RLxLYBMWjmQaj7Y4qv4FIo4eQh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_09,2023-08-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2308090093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  9 Aug 2023 11:17:08 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> With somewhat recent GCC versions, we get this warning on s390x:
> 
>   /usr/bin/ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies executable stack
>   /usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> 
> We don't really care whether stack is executable or not since we set it
> up ourselves and we're running DAT off mostly anyways.
> 
> Silence the warning by explicitly marking the stack as not executable.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 706be7920406..afa47ccbeb93 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -79,7 +79,7 @@ CFLAGS += -O2
>  CFLAGS += -march=zEC12
>  CFLAGS += -mbackchain
>  CFLAGS += -fno-delete-null-pointer-checks
> -LDFLAGS += -nostdlib -Wl,--build-id=none
> +LDFLAGS += -nostdlib -Wl,--build-id=none -z noexecstack
>  
>  # We want to keep intermediate files
>  .PRECIOUS: %.o %.lds

