Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8160B3C43DC
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 08:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhGLGMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 02:12:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231351AbhGLGMo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 02:12:44 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16C64duN095611;
        Mon, 12 Jul 2021 02:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QwcRWDHzaYwT2PNMzWVzEMbP1Sm/r0O5ahengU3yrpg=;
 b=DtN2Y+Bqolp3JBes67gqBbpu+H0d5jolFsvKt5F5dC899DnAUH/Kopw2c3Xr/riq2zUb
 yWnztBzcAPeQT9P2xCx5+69EX9lFgcxophB4Vr4mpAMm/r9FBYG58xGhZd4JsNnlCfvZ
 /pXq4MQhe2BVhkEiX153aNCWmHivFU1yHfDwfy6nFFJOp1jBWo1ZF8x1qFVvldHEfl0w
 joDfSljA0SCkeyQLDWOZM5M7keGSezt0JwICYFB8P4SwIQwIp14+tOvO8lKTQhyFaysj
 xtWmLXEYReX8IQti4IaQ2OrOtMJnuteQHYLRMGWOeG70W0qBKvdDY++qnLGwGfM7sk3h VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qrmcxswk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 02:09:45 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16C64veU096337;
        Mon, 12 Jul 2021 02:09:45 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qrmcxsw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 02:09:44 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16C67TPe016984;
        Mon, 12 Jul 2021 06:09:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 39q3688a9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 06:09:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16C69eEr28639598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 06:09:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7368BA4065;
        Mon, 12 Jul 2021 06:09:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 024DBA4064;
        Mon, 12 Jul 2021 06:09:36 +0000 (GMT)
Received: from [9.160.8.119] (unknown [9.160.8.119])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Jul 2021 06:09:35 +0000 (GMT)
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <8b053bdf-42fb-d329-4cd8-f326ad98e10b@linux.ibm.com>
Date:   Mon, 12 Jul 2021 09:09:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709215550.32496-3-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XmOcEoLLDVhPvXTWyx_kxZuX3LeDlxQN
X-Proofpoint-GUID: yCsM2qik6evqdrca-lM__5ctpe1NStui
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_04:2021-07-09,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/07/2021 0:55, Brijesh Singh wrote:
> To launch the SEV-SNP guest, a user can specify up to 8 parameters.
> Passing all parameters through command line can be difficult. To simplify
> the launch parameter passing, introduce a .ini-like config file that can be
> used for passing the parameters to the launch flow.
> 
> The contents of the config file will look like this:
> 
> $ cat snp-launch.init
> 
> # SNP launch parameters
> [SEV-SNP]
> init_flags = 0
> policy = 0x1000
> id_block = "YWFhYWFhYWFhYWFhYWFhCg=="
> 
> 
> Add 'snp' property that can be used to indicate that SEV guest launch
> should enable the SNP support.
> 
> SEV-SNP guest launch examples:
> 
> 1) launch without additional parameters
> 
>   $(QEMU_CLI) \
>     -object sev-guest,id=sev0,snp=on
> 
> 2) launch with optional parameters
>   $(QEMU_CLI) \
>     -object sev-guest,id=sev0,snp=on,launch-config=<file>
> 

Not directly SNP-related, but in an internal communication Connor told
me he wants to allow the SEV configuration (like dh-cert-file etc.) to
be set using QMP commands when the machine launches instead (or in
addition to) setting them via QEMU command-line parameters.

Whatever the configuration solution decided for the SEV parameters
should also apply to these new SNP settings (policy, id_block, etc.).

-Dov
