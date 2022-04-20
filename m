Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31E9508B80
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379799AbiDTPGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379883AbiDTPGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:06:07 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8FF4553A;
        Wed, 20 Apr 2022 08:02:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5VrS6MrP+dA5jYQURsPRJypLN0JB+lM7IJ+gWZqBELpADDaUXnSVW27QpfE9OYPzgcNNdoVrojXVzK82n7R7UmMBYXJGJzREhJyNQvhRyhUKR7MPbMQ2JNAx6s63zInCOwmp3vZsvRGTc/aus+SLv20aSivJGOawlkk78nUQXmqvexNay1Dzaxijgo06VxGHxi4Vp5pYNP/Cit18HHZ7SW0LGURSTNdmdFWQCrywpKccTb2SFP/K4tlWKu505WHSUm5WxI1d3jTGDdUZakFmHJ1zV66g488JL3G63uBZtqh5C1uP3bdjWooqxz8PB9X1/9pFiD5O+YN4AziDMpZZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZcln9eVISDec3FFyoMgyAx6ve2w8LBtG0PXWpBDrHs=;
 b=i8zqkfLLOSj8dTYgbmN+nOmEybyiwDhj0kndbquLyplJPkErZr0s7RvNhEY2sloSaRO5saRKMyKoMRvz9QnugVwc/hrTlGvvsboK64SVah1DubkW/VRhLYZY1zZSbSVSTXP3oD3MJVpCcwVsBv5+FmpweMksaaJpvFB0Kn31aeHfok5TvrqWJE2Y8I6Oijme27n+hObGBED/KaDKMINJ5PSp3PKMdGksYwDWKwkxtK2rAD1FW+oFpbfCjh7D+lAsrkcKqRSGeoQOo1OxQomDDu7TKp6zc1q0R44lwb4zudb2faG2Z66NbMSwh2oDJx6UsRLTvORClGQ55aXJonTQiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZcln9eVISDec3FFyoMgyAx6ve2w8LBtG0PXWpBDrHs=;
 b=PLXtHcl8N5tPLOTWLSnVct3jB46jAbaSZ54eMBAijS3+opu5uLUi0mzjQqhi3foYzIdeJUC5eNzbJyDAVlIGCRdC2c5okNjnT3viiPl2BvSWCG+ofOdLdixNq0AM53NR1o7Qdn2wNCuZB/Qdbn2E7tarN7oYHOnSC/wllFz68CU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by CH2PR12MB3975.namprd12.prod.outlook.com (2603:10b6:610:2f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 15:02:25 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::f42a:9b66:c760:9fae]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::f42a:9b66:c760:9fae%9]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 15:02:25 +0000
Message-ID: <186da20a-c4a2-98a1-1027-7b4390bf8cf2@amd.com>
Date:   Wed, 20 Apr 2022 10:02:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v2 1/2] x86/cpufeatures: Add virtual TSC_AUX feature bit
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        wanpengli@tencent.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
References: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
 <Yl/x2kpQeKylIyPb@zn.tnic>
From:   "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <Yl/x2kpQeKylIyPb@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0168.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::23) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cdfa2a1-a72f-47fc-f3d4-08da22dec73d
X-MS-TrafficTypeDiagnostic: CH2PR12MB3975:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3975462B4A33286E91DE824395F59@CH2PR12MB3975.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3dUKinNycZdZd2ED0T3VTEn684Xs78KMnLSk6noV7oLOXlck8RQSx++DJG0UctclDIHQos8XsfolwalCHNxryraSpc8jTuzHh5TcaZHHrFzeXCrt5N/tqjSy2o7gioVo7y7YyIIvItBvSvANZDppcf1sVO25ufj6pb/MnakMgSAyD1ZHiUz2TwyOo0NuoXxcm51FR/me2H4DlWcsMSD2S2t0macEANvZk74GbWNZ06j7WBocmvdSsaF/p2OcUYF6dhnUT5pLYAh99OexOwFJhV6D7QqX0u3udvvDaVkcMOAAFNGG9a8u0KIpfZgB+vq10NTM0g/8mhMsFXM1a/IgkU+7ej4o9L5gSubUGCoF/Kh1rrkurB3Sin6Jm7iWN0eQ3rKc2lUGPC6DL/i5VaRJncBAfRrOctpECcNN98t2AdvTCi4MEZi/W9meGcYhYPcKp/Ph+b+yH2NUF/kpjMtZrPDCsj/cT5SsIVl2CaYX6/0dQMcNKsN/VAjswJiBuPp9ExBCt5fDqPY4aPgfg+7IjRCfedL65qFFlAv6wr/VoNcIqTAr6R9OmAVylUJSSL4x498zr7MlLP7Ex9yBkkqCwy+ZKTjTzk20N6xD19MVN7Sidogqkl1s2NJl+sGgLDaDY1Qurc0PKhSndKWBoWd0Iga2RPSM7DSSfZxVxYJgzLEtACc3tcgRAdyKXaipKajw28B/57h5INZghf58Jbg9JtN40mmKgHdzGnictLFqSV61dA+yx4DuxEr78t10IToeTBZb3Yhlp7bSnpl4ivnc7FQCpyRY6ThdYVul/LSYUSBjylSByTU4+4OgsInvW2P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(8676002)(6512007)(86362001)(66946007)(66556008)(6486002)(508600001)(38100700002)(36756003)(66476007)(53546011)(3450700001)(6916009)(6506007)(45080400002)(7416002)(2906002)(31686004)(4326008)(2616005)(966005)(5660300002)(8936002)(186003)(316002)(83380400001)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3ZtUUdoZk5UYnJLNG51V3FIbmxIMEYzdlM3blVxSVg4amNKQyt6dGQ0Z0RQ?=
 =?utf-8?B?dkVYajRkdlV5TmRYTGRFS1BZWWZ3NlZQTzJvejQ3akpnREpBZk40TXZmQ2hX?=
 =?utf-8?B?eVhNejJZWTFFSW1NQ2g2WmRQMWNkOEVoSXp0RmtsWWt0WDNKSkZFVlZab0tl?=
 =?utf-8?B?UzFacEhvbzMxbis3bmJoLzZubVBBU1YyNkdQUUtDSU14aEZQcjJTNUkrL2k5?=
 =?utf-8?B?VDJDb2IrOFVQNU11d0VrNVNKZ015RlRtRmFxOTJTeXhMZS9lVkJMZzNzZ04v?=
 =?utf-8?B?aEdtRWNQcU9mRlR5Sm85elZLWHlpZnZlblc0R01PNU1NWGI4ME04dDJSZjZV?=
 =?utf-8?B?dG85ellVdUl5NG91WUwvOWJwS25ZRjdPYWF6SDRNUTd2OEdQSERqTGswUjlh?=
 =?utf-8?B?VENnK1paSktYY0VkeEJ1OUZaQW1JVThTRHI0QktSUEFLSFRhU0RWN21ZNGZL?=
 =?utf-8?B?ZXlLU0NkOFRISzIwQjY3TlNXMitHa3B5a1dnc0Y4SDdwVUtFOHJxN1lZTng0?=
 =?utf-8?B?cEY2a054M0F4S2pmcnNwa2RIem0zVTV2Q3c2SCt4QlFyRkRwdVVSS0VCY3pt?=
 =?utf-8?B?Mzdjd0ZET1l0djM0QVhJOHY1clhGdG1JOFZNU3JzK0RBUUlrM1R0OFVpNWlU?=
 =?utf-8?B?UHkxRGZuUSttRUxHd1dPckNnZVpQMGxOdmNiam96T1h6YjBublJLaUI5MW9D?=
 =?utf-8?B?VmdFamMrTFhwVFpuQ0VQWjgzQjRKejZZRVdUR0ZwV2tvcHVHOTdTSGgwNURR?=
 =?utf-8?B?dzRZK3JRU0RQb0NXQmdDMjF3STBleGt6bW90M3NQZTZPK3FNWDc4TmhQU05a?=
 =?utf-8?B?T0E4b0JBZnhvalZwMkQxemxpTEd0dE5BMmlUS0Z5Vll2NHlJSTF3YXl4Y1BQ?=
 =?utf-8?B?dHlFOVYwVWRBaGJtNnRTemVJcVpuRWtHMTEwbWI1MmFRMG9XSlFCMlhpWHJ3?=
 =?utf-8?B?MFdUZUpIaWo1dks5QjNoQkNXL3gyQldYVzZDaWVRQzcyazhaaFc4MGRuVkZL?=
 =?utf-8?B?RFZFZ2pGWEpObjgwNmtlUGl5L05YOW14S0lHb29qWGhSOHB6K25Sc1JnSjZI?=
 =?utf-8?B?ajQwWmJaWFFBUWhoSmo4M0F2YlozbTZ2cVlSRS85MXU5TmVTblJvMEVTRkR6?=
 =?utf-8?B?RVRyVUdVSjZRdlZsTm5oTnc5WGt3Y0Z3NUl6SzVlYlhjVVIvMTc5Qzk5NXZq?=
 =?utf-8?B?RU9jWnFtOHVPOFlEU09WRlJtMjdtTVh5WmpzNStCZXlKbFlFc1lobHlqeXQ3?=
 =?utf-8?B?Z21sTmsyNVI5OW5GYmJzelJKTjl1OEZTWVA1RnFha1VMTjlsVDh1Wlp4cWVz?=
 =?utf-8?B?eFlESXNDcXJuWEVwUDdEZHJ2OFVsQ3MrMUVabkRGVjl0ZWlDa0paK1NidUdr?=
 =?utf-8?B?TG93T2FzQ0VlSVE0UTZFUUg2b3E5VW9WeWdXQUh4NVZhVm80cU1NZWZReSt3?=
 =?utf-8?B?WTU0Ym5WcDk4MXhuSWtpRlQ0b0owK0o1NWw3aWI3YUFOZWVQeWdMRGxmTGl6?=
 =?utf-8?B?Q0ljV0dibGpkOEtJZDkvdWhTNklOY2FsdUhyVktXK0hyZmRudk9yRVJpOFN2?=
 =?utf-8?B?aTZlN1lWcnBOZytwOTJDaU5YeE1tcFF6WG8xMmI0THM0elZRVWpNK0FzSzYw?=
 =?utf-8?B?cGpBSXluR2h2OVM1Nm9BYXdGQUtPd05EWXBoZjhtWE9Yek42UHpoTTJBcm0r?=
 =?utf-8?B?aTlYUVdrY3l0Z2E2VnBPZkRsdCs1MWZtdFpSQmU4NXQ4b051bTg2eS8zUlF3?=
 =?utf-8?B?cm5qRCtocVRSMDQ1dlh4bmkrbkRqaVBCa1JvcW53Y1Q4WExTNDFiZEtORTdK?=
 =?utf-8?B?eHdvRVlsWkZrM29PMjBSZ0xzMzlYcFBqT0FuOGZWUzhZODBVSExhZjV5VWpN?=
 =?utf-8?B?SjRORzJvSlJmaTFZYklIOUhXWG9jdGNMYktjTHpxaVRVV01acUt3eTQ5SExW?=
 =?utf-8?B?QTRFNjNVdlF3TEtBaUVqWGRGa3JKSlc4UFVudTJ4V01jNXducGI2OS9UeVVM?=
 =?utf-8?B?Vm5nMWU1QWdiY1hTR2gva2ZqWUdSRjJsbGllUWJPbjhzOU5xK0ZKTUFsT3Bw?=
 =?utf-8?B?U2lvR2NTbmxXZ2tjS0k5NzBZYi9UbGlWdU1XVWgwK1JlMkRrUENTZ3MwRVcx?=
 =?utf-8?B?MVI0NnRhdU9SY21aRHlubnN5V0w5d3REUHRZWS9Va0J1aGx1Y0JJQlJpWUJy?=
 =?utf-8?B?MTY1VkZWYmpIK0VqYTUzNEtCVFE5OEhVK25VV0VMNjBTK3dYQXpKeFlNSHpw?=
 =?utf-8?B?ZWZFY0JOcjFMMitGS0FLek9IVjdHN2xQN3NTTytiVVBOWlpPWkk2S25HVnlj?=
 =?utf-8?Q?ftPGzGW3RxP7osIzXr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cdfa2a1-a72f-47fc-f3d4-08da22dec73d
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:02:24.9358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KpwNEI/j0UG2PAvtkmB0jXsWOFB0q9hLdNGET4VV88Qes/HGWmQgbtclIhKRXml
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3975
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/20/22 06:43, Borislav Petkov wrote:
> On Tue, Apr 19, 2022 at 03:53:52PM -0500, Babu Moger wrote:
>> The TSC_AUX Virtualization feature allows AMD SEV-ES guests to securely use
>> TSC_AUX (auxiliary time stamp counter data) MSR in RDTSCP and RDPID
>> instructions.
>>
>> The TSC_AUX MSR is typically initialized to APIC ID or another unique
>> identifier so that software can quickly associate returned TSC value
>> with the logical processor.
>>
>> Add the feature bit and also include it in the kvm for detection.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Acked-by: Borislav Petkov <bp@suse.de>
>> ---
>> v2:
>> Fixed the text(commented by Boris).
>> Added Acked-by from Boris.
>>
>> v1:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F164937947020.1047063.14919887750944564032.stgit%40bmoger-ubuntu%2F&amp;data=05%7C01%7Cbabu.moger%40amd.com%7Cf826192970c549ae73af08da22c2ff93%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637860518176768607%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=fExIt5ghvuew%2BXKzGyixye2%2BLQncv91274nt8I0NXbY%3D&amp;reserved=0
>>
>>  arch/x86/include/asm/cpufeatures.h |    1 +
>>  arch/x86/kvm/cpuid.c               |    2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 73e643ae94b6..1bc66a17a95a 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -405,6 +405,7 @@
>>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
>> +#define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
> I forgot from the last time: nothing is going to use that bit in
> userspace so make that
>
> #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */

Ok. Sure.

Thanks

>
> please.
>
> Thx.
>
-- 
Thanks
Babu Moger

