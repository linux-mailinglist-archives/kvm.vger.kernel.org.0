Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3016A57D1A0
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGUQg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGUQg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:36:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AB51D0EF
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:36:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LGaIAZ012659
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 16:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tkS+Gp01EK5cn/tLmSkkf/7iv0WHkElr+pYFrapBi6c=;
 b=hswZyKwPHQmfP2LiJo95qfD5dfVTyqvbnwV1LiJUJU4495td/kjS3IuEETkmK3Ovu7OP
 Mkj3QJLv+CCg+5YCaIeEdHVH8A00dPc7BIzfEvs18cF/NJSl0SbgtwExxB0VuI6YjOGe
 wNXhPFlA9mDKSaWgTpbwMgL4CLlN5x7bwgp/shTclHKPVxShxrwaFpI8i/Fi9n/SAPbL
 +UJfu570PdqacPuElPtoQ42wnJJn+OrS1ODEZ6SjtHBPnXg38rfxTT4pqI/Q6UiBp3dW
 mfUL9Xr5y/BraboIkQ4jAH4Cz0orRJF9vGfJR/+E4/kkhbIkETskvFs8/y9Qy0vHkIPr Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4sc83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 16:36:24 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LGIpGW018800
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 16:36:23 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4sbup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:36:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LGMxLF008677;
        Thu, 21 Jul 2022 16:32:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8wf4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:32:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGWunf24642038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:32:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1802B4C04A;
        Thu, 21 Jul 2022 16:32:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE34E4C044;
        Thu, 21 Jul 2022 16:32:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:32:55 +0000 (GMT)
Date:   Thu, 21 Jul 2022 18:30:29 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: factor out common args for
 genprotimg
Message-ID: <20220721183029.15f7ac2b@p-imbrenda>
In-Reply-To: <20220721132647.552298-2-nrb@linux.ibm.com>
References: <20220721132647.552298-1-nrb@linux.ibm.com>
        <20220721132647.552298-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kwubjQ6De0P2ALo3VlEkXIQdNDXMOmd4
X-Proofpoint-GUID: T7RaVpkaXOBNTOsDq_N_cKX5BHEJFogb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_23,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jul 2022 15:26:46 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will add more arguments to genprotimg. To avoid
> duplicating this logic, move the arguments to genprotimg to a variable.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..34de233d09b8 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -165,11 +165,12 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
>  
> +genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify
>  %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
> -	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
> +	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
>  
>  %.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
> -	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
> +	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
>  
>  $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<

