Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5D34C2857
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiBXJnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 04:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiBXJnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 04:43:12 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9B027DF10
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 01:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645695761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kv/uqualmPNSI75Ve+qZ3cZifKQjEcfRJg9jXAFwUHI=;
        b=DaWT2azhuvUtOUJKtv+QJ5xlZ7jZdNDVVNkdwnbeTGD1VanzwatOHOT/KJwOGGbi56z25p
        uY0u+xxBeuszNoULAa/7qfrCxkGtjETU1iqc08eNyq5JP3e1JEzTu5d+uxBzBRs3zyT1tX
        L9EJYFMf9qrCr9COh6toXZ6fTh22KZ4=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-96rT9mKdPE6GETwOJrRt9w-1; Thu, 24 Feb 2022 10:42:39 +0100
X-MC-Unique: 96rT9mKdPE6GETwOJrRt9w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lw+ae/zLF646p3UrgZhdW3mId038BhX7en82K4pSrWeRsuRQlPlJQqc8iKU8ZvaY+2G3N1LYDcL4JBc+9gsawlTlXBqZVE5wTm/tVCa2SRIROlS9qStRquuo5bCdCeBCzu/xFc1xYRoQBHEe9pVf30WoY92p9EXRQCwxSPLiI6UZAVmU3ADUWXbs2NJ5xDkjqOyl3wfDJ/jII9VkgtamZ46P1MNQAAT3ZjKLG0oOgxoY3VvqF60JshUixLrnmb5zBsQ65/aIJ0Wfedxs+c8daEkZmG8tOZs0BaBMO3U9lqbUcmoVEL0tcazW1w9EZw0TaG+pyO6jwqOqEwtpkMomQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kv/uqualmPNSI75Ve+qZ3cZifKQjEcfRJg9jXAFwUHI=;
 b=XQAFy6NDQDy+ggUgsdF0f+VJo4UKYLiEtceBeOZk4A3LiD9HmQSzJPLdYPvmhjdG49zNmdbPMC6tpc51lTjfVEUgbMQINGQmdRnUklkyG4Xycm7GA5oN+9Z4w1lE63vz7eDjYXNRkddBpyhgIq4u+SWR0WXhTJg/iwwlOlP0aA/TiiV3P/NPuj/zjdpJwzfU8uJM2WpeHQNMgwbc24FJ5AH5/F2F6t8kc/VzbwWlQ8+hoX1TjaEzvk9APlyBGsi6evL9Tq2uQ/7gpcuz8CtlySN0Hqgloe1DkI6uQpmjJ686GPP3ByFyzM5A3G/o/0nmvA3neBHL3jtp09iCqddDKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by VI1PR04MB6173.eurprd04.prod.outlook.com (2603:10a6:803:ff::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 09:42:38 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6%5]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 09:42:38 +0000
Subject: Re: [kvm-unit-tests PATCH v2 10/10] x86: AMD SEV-ES: Handle string IO
 for IOIO #VC
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
References: <20220209164420.8894-1-varad.gautam@suse.com>
 <20220209164420.8894-11-varad.gautam@suse.com>
 <CAA03e5FR9mV1XtR9958rRh0ZPbZtcAftOvS6DxxD2zaVtKHX4g@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <29125b59-cd7a-6b51-61f3-709b15638246@suse.com>
Date:   Thu, 24 Feb 2022 10:42:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAA03e5FR9mV1XtR9958rRh0ZPbZtcAftOvS6DxxD2zaVtKHX4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0111.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::26) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46b1f9ca-a9fa-4b9c-bb60-08d9f779fe69
X-MS-TrafficTypeDiagnostic: VI1PR04MB6173:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6173A51AE1D53BD90C005FCAE03D9@VI1PR04MB6173.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2b//CtuoMxsPYIeAFymfzIaQBzEGiMroHJPA8HwNWtUxNaWYHNFSXjfUDahSMxXCO8+iHaHkLMhksr8XeNcqtG6TyTSak7D4B+0nCFGPYpu4fgfxnAV4n+36kH76SykrONSfJm/iW5Itpj+s4wxz3nP6gt8cWryX36868tcnKl4nGZrxlzuFhTu+WRcv2U/bk/YXiGYMJ2783zcm4Wtnd5yb6rRJONkmY73c1lKJ7yfzjNLxJ/EM/ewK5v5j1/F7Q25B0R1lepYVPdSKlb9DPutxVWpdgMQqMC4Pl+z/xI5qXdJOgGthklJIZlrU1C0mmfGauBCfUS6jKocLb6EpsuLv+j9KaUsim1XSeCyOGfM2f+mpT+uy7WBeSHMy62BxG9DwTpnmRzISgJPVMDkJBZhrinf+IRGW9FTY25jpK2yoaFdDfZi4zfwYJH6bwhqnIxBq3/3yBlGn6ZZFz2997O7gA9xImIeTBhFW8AkHhC1CEco0JccKThuLXs9dmitSpNN04npJTHl2GqNpU0vj/LvQZSm2mehtzzTOGY5thrgXxzfACK1MvYGNip0MxlnX+Z0JzQyahbRrjLIJwgqqUYcsFur9tGMSHSGMZy65Xtz13swZgz//E6FNWnWXWuQqnTlpoxjt6fR2aygbaDFRgKUt6D2bqmOq/ha7r4QbVbOeIRTdJ/BfS48nMSPxcs7RBdZoMIxK5U/2IIlEbWpjuZjk2gGSBcWp/FMe/skWtv4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(316002)(2616005)(38100700002)(6512007)(44832011)(54906003)(6486002)(186003)(26005)(53546011)(5660300002)(6506007)(86362001)(7416002)(508600001)(6666004)(31696002)(8936002)(2906002)(66556008)(36756003)(8676002)(83380400001)(66946007)(31686004)(4326008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0R3QklFaXZFeExaN3BxM0pISG1ETXFzM3Z3dVRVL29xOXp1NDhYTVk4Lytj?=
 =?utf-8?B?UUlSK1g2QndIb0NSZkpzOTNDMitSQ0hzQUlZcEFDaG5VekhaTnp1bzY1WXQ1?=
 =?utf-8?B?alVmUHlOZVdoajhyWk9oVWxvSDlPQTVvazgyUVJ3QzZQZWdpSjNmMmJaWGVz?=
 =?utf-8?B?NFpOb0IreDBkOUUrNFNONWgwdHdiOG9XcXkwR0RHdFc4Njd0eWNYWXBCNVB5?=
 =?utf-8?B?cWpKQmlTTmJvMHF3dmo0ZE5TSDBTTzc2ZzUvWlVuOWRDa0ozc2FFWUFZSllH?=
 =?utf-8?B?U1FLZU5qOHJsRjdKSC9UVTFmTTdma253cDB1RGNHNG9xTDh2aHRuMm5lWWVo?=
 =?utf-8?B?Mkd1V2RLalRFOTVYaTB4OGE0SUw4OXlBM05ONTg3YWU2NTU2cDlKSlNyN3pp?=
 =?utf-8?B?ZHdPVlJoSm5BNEsxRWpkODFneE5HbTF2SGFycFVxSWZVQXA1eXBFQTcvZmFz?=
 =?utf-8?B?SFlCUit3VjlCYVlDZDF2cU5oamdCSFlnZ2IwVG1KT3UwbERxOTV6NjBtUmtk?=
 =?utf-8?B?cXhaczRGMUY5SSs0VTNhbHJMOFk1VDVSYUlsK3NyOGFDVUx4QkxhYTJiN0pi?=
 =?utf-8?B?eHNLN1hQQk8xaDdudDhqNXVlNFd6YnkwUWk1cjBLZmxPS1JoMGVBWmNOOVdq?=
 =?utf-8?B?R3ZNcjg5eVh0SFRFYUpFcHdIMk95RGhQLzY4QnBzRVNOOHY0dTZXNC9pRGYr?=
 =?utf-8?B?djl2L3lWdE9EbEVkMXYzdGdzTENoNFhoN3ZiRjhSbXFsZ0xibkR0Nm5WeHJ5?=
 =?utf-8?B?YmRuTVlSRU1ZZkE3WWk1a1o3M21SaWY0ajc0aE40cGZ1ckVmdXF1c24yLzVX?=
 =?utf-8?B?ZnVKcGhBbFIvYmc3TlF2VWxxcGdycDNoQ0tuRHpmM2trY0piYkhwb0FQd1di?=
 =?utf-8?B?Rm1QZ1hHcXdMbVBPbjNyeWY2dVo2akR3RzR5R081TWxuM1BFMGdGS0JkSWNK?=
 =?utf-8?B?VnhMdjlvTkJsSERUMzBhcGZBcklGemErUFQvbjJ5aE5KS0Zoa2YxcU45Wmlx?=
 =?utf-8?B?RHNBUXNhU0g1dmlzb0tQNDVGa09idll1Uk5kZEdqWHR1YXU1ZmduUVA0WC9l?=
 =?utf-8?B?RHVGQ29MVmNzaWdsYkJ2N1pkVURsVmh6OHpZejFjODZvZHl1eWd2Mm1PdUhr?=
 =?utf-8?B?Y3hUV2xpRGRDMEoyd0tybElzRkFPSjVSUmlFMG55T2ZMeE4wenBmZEdxcUdV?=
 =?utf-8?B?Y1kzTmtLQkxQR0JXc2VWdTBVWVhmS01NenFmRXRrSzZ1c2g0RHdCTnUrZmJD?=
 =?utf-8?B?M3MrU3hhekdXcGNlUmdodlgxaWlEU3NtREV4MkYyZm5VQWIwc0luS3FOaEtZ?=
 =?utf-8?B?QXYwRGtjWnlnb0lQOVBpS0FycXpGS3FucnBmMlZ1by9GN1V4b1ZVRW5qZ05O?=
 =?utf-8?B?WDluM2h5TVRlQXNOYVpNR05xdDlaMWlsbTBKdFEydFFQUlFzdk1mL0NYWUFw?=
 =?utf-8?B?OGRqTVlic0hhWXp1dUxRemlwdjZ2NllDSmZXc2JLTkkySXU5eVphVGNTaFgr?=
 =?utf-8?B?VTIyNGF5YzBpZERucmxJeE9McTlBREJYdkMrRWJXM0lnZnZDVkIvTzRVeHRv?=
 =?utf-8?B?ZkJMcmR3ZldGN2tleko0VWEzT3FVSHdDVXJEemVJcTdvS3BBK1kwd3YwTTFn?=
 =?utf-8?B?TVR6Z0hlbHJPRi9Ic0dNSEZqUytXczlIZjVvaEk5S2JwTkdIZFg3L0lGbjNX?=
 =?utf-8?B?YURUL2lsb1NKNEkyakdEYWpGZTB6UHdvT0xpWGJFVVdTL1VhTmR6d1BGWjlV?=
 =?utf-8?B?c0hUdGtFbTRMWmVMSTUzelNOR2pkSHVRQ2JvRzZvMzdLUTJlOFpiaWhoMU9N?=
 =?utf-8?B?Z1A3ZktkUXNJbDdMVzVPU0J4eThXZDg3YTBaYjh2Z0RXSlNaSytSVFFMU1Jn?=
 =?utf-8?B?bnN1N1llV3J3a1E2NW82NmxKMiszQkZyR1NkM1k3V09zdTV4SXlIL1VibTJX?=
 =?utf-8?B?TExHUnAzNkFpQWpXekN5QzVrTG15MG9KNytLTGswajRGMmdvcEtEZER1WUth?=
 =?utf-8?B?UFRIZVZoWEVQTnk2R1hnVE5vcVhrNXB5NU1zSVN0bEx5MGpWS09wVGVzWUJQ?=
 =?utf-8?B?VWRsdDJpZmp1am9HSFN3Y3M3NkNRemIrRGVqNTlRS2hzK21Rd1l4bjVoTDVo?=
 =?utf-8?B?Y3VIM1dqN0RIbU9VUkZxZ2Y4SEVzSTA3SHdkZ0ZUa2lIKzFWRUpYTlp2c1BC?=
 =?utf-8?Q?oxwbmxT9Qn4Fuu6QU/qIgx8=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b1f9ca-a9fa-4b9c-bb60-08d9f779fe69
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 09:42:38.1862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KJe8nDZnA4uMb9+glALxb01YIP/S5QGkCKzxGKeCGT/Q3NZFcDlznF+mB5LLJfrKuYjlR+YsxxZashA7lVAkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6173
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/22 2:31 AM, Marc Orr wrote:
> On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>
>> Using Linux's IOIO #VC processing logic.
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>>  lib/x86/amd_sev_vc.c | 108 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 106 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
>> index 88c95e1..c79d9be 100644
>> --- a/lib/x86/amd_sev_vc.c
>> +++ b/lib/x86/amd_sev_vc.c
>> @@ -278,10 +278,46 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
>>         return ES_OK;
>>  }
>>
>> +static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
>> +                                         void *src, unsigned char *buf,
>> +                                         unsigned int data_size,
>> +                                         unsigned int count,
>> +                                         bool backwards)
>> +{
>> +       int i, b = backwards ? -1 : 1;
>> +
>> +       for (i = 0; i < count; i++) {
>> +               void *s = src + (i * data_size * b);
>> +               unsigned char *d = buf + (i * data_size);
>> +
>> +               memcpy(d, s, data_size);
>> +       }
>> +
>> +       return ES_OK;
>> +}
>> +
>> +static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
>> +                                          void *dst, unsigned char *buf,
>> +                                          unsigned int data_size,
>> +                                          unsigned int count,
>> +                                          bool backwards)
>> +{
>> +       int i, s = backwards ? -1 : 1;
>> +
>> +       for (i = 0; i < count; i++) {
>> +               void *d = dst + (i * data_size * s);
>> +               unsigned char *b = buf + (i * data_size);
>> +
>> +               memcpy(d, b, data_size);
>> +       }
>> +
>> +       return ES_OK;
>> +}
>> +
>>  static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  {
>>         struct ex_regs *regs = ctxt->regs;
>> -       u64 exit_info_1;
>> +       u64 exit_info_1, exit_info_2;
>>         enum es_result ret;
>>
>>         ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
>> @@ -289,7 +325,75 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>                 return ret;
>>
>>         if (exit_info_1 & IOIO_TYPE_STR) {
>> -               ret = ES_VMM_ERROR;
>> +               /* (REP) INS/OUTS */
>> +
>> +               bool df = ((regs->rflags & X86_EFLAGS_DF) == X86_EFLAGS_DF);
>> +               unsigned int io_bytes, exit_bytes;
>> +               unsigned int ghcb_count, op_count;
>> +               unsigned long es_base;
>> +               u64 sw_scratch;
>> +
>> +               /*
>> +                * For the string variants with rep prefix the amount of in/out
>> +                * operations per #VC exception is limited so that the kernel
>> +                * has a chance to take interrupts and re-schedule while the
>> +                * instruction is emulated.
>> +                */
>> +               io_bytes   = (exit_info_1 >> 4) & 0x7;
>> +               ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
>> +
>> +               op_count    = (exit_info_1 & IOIO_REP) ? regs->rcx : 1;
>> +               exit_info_2 = op_count < ghcb_count ? op_count : ghcb_count;
>> +               exit_bytes  = exit_info_2 * io_bytes;
>> +
>> +               es_base = 0;
>> +
>> +               /* Read bytes of OUTS into the shared buffer */
>> +               if (!(exit_info_1 & IOIO_TYPE_IN)) {
>> +                       ret = vc_insn_string_read(ctxt,
>> +                                              (void *)(es_base + regs->rsi),
>> +                                              ghcb->shared_buffer, io_bytes,
>> +                                              exit_info_2, df);
>> +                       if (ret)
>> +                               return ret;
>> +               }
>> +
>> +               /*
>> +                * Issue an VMGEXIT to the HV to consume the bytes from the
>> +                * shared buffer or to have it write them into the shared buffer
>> +                * depending on the instruction: OUTS or INS.
>> +                */
>> +               sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
>> +               ghcb_set_sw_scratch(ghcb, sw_scratch);
>> +               ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
>> +                                         exit_info_1, exit_info_2);
>> +               if (ret != ES_OK)
>> +                       return ret;
>> +
>> +               /* Read bytes from shared buffer into the guest's destination. */
>> +               if (exit_info_1 & IOIO_TYPE_IN) {
>> +                       ret = vc_insn_string_write(ctxt,
>> +                                                  (void *)(es_base + regs->rdi),
>> +                                                  ghcb->shared_buffer, io_bytes,
>> +                                                  exit_info_2, df);
>> +                       if (ret)
>> +                               return ret;
>> +
>> +                       if (df)
>> +                               regs->rdi -= exit_bytes;
>> +                       else
>> +                               regs->rdi += exit_bytes;
>> +               } else {
>> +                       if (df)
>> +                               regs->rsi -= exit_bytes;
>> +                       else
>> +                               regs->rsi += exit_bytes;
>> +               }
>> +
>> +               if (exit_info_1 & IOIO_REP)
>> +                       regs->rcx -= exit_info_2;
>> +
>> +               ret = regs->rcx ? ES_RETRY : ES_OK;
>>         } else {
>>                 /* IN/OUT into/from rAX */
>>
>> --
>> 2.32.0
>>
> 
> I was able to run both the amd_sev and msr tests under SEV-ES using
> this built-in #VC handler on my setup. Obviously, that doesn't
> exercise all of this #VC handler code. But I also compared it against
> what's in LInux and read through all of it as well. Great job, Varad!
> 
> Reviewed-by: Marc Orr <marcorr@google.com>
> Tested-by: Marc Orr <marcorr@google.com>
> 

Thank you Marc for going over the series! I'll have the v3 out soon.

Regards,
Varad

