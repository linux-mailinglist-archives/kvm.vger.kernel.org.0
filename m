Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A042E42FD3F
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 23:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbhJOVO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 17:14:27 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:38369
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234257AbhJOVO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 17:14:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FS4wBllWcyyCxTPiL7RK5WN7AUP6+HZqFH6osST77X2R+JE3MS+ndtA/jb01FJ4WYc8MkvlPUblIqTBHoz5E1t4xEgq6ycMSFSRAXz5YbGeK9cy6ndyj5BNcXbzjlhFwu+mKcJmPxP/3ZJPE+YUb//cWP8pcusGndLedJemI9NqggNxsDaGaFHhC0R9buihtey2tIf9aUlEAixEVr75SZFs3oeKMJnuN3RAMFRSUbv6WFqZO/IMdMeZNID1KQwPNB+r0GRpxBc2lPrwkynShg9CNH/+G9gdW68t35id45zcLihPPsBL2+y5IMZZ1Q27NXJp5IVoxUgbcN+k9F3pv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ddKqpVAdbvZ416rQW9zqpp/ygtZzzBoHmtWnVyXc5j0=;
 b=NB0vEIU33CobNlrk4K1TRBY6fwdOZAHWilJDR7fQHz7TUCJs0Z1L3mywTL/8eoDhsnioqa9zJEpECDFa9c56mkqjza2idoOnM9va5EhBgv2mwuZpyrsbYUVzMBwnMS/SYh4TOKmSncgjizvJgtDw8AeDI2d/uJv/lVKKi8RmC81ZzeW3KZ/OwrlzFzyp1MqJQmsX2QfrfGJ2E67IgRVD0PJyATJQ+anrZ8JI46nwtCaEeyCpVkhixAZQRYey6pSlsfHPPoZOe6W1r/gyx3pSDYKDtqwDI6erTCW+q8gMWf/z2n3/PgpuRGBsE8rtK3tT/8VQeB1ML7btlxQIMTWpCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddKqpVAdbvZ416rQW9zqpp/ygtZzzBoHmtWnVyXc5j0=;
 b=ESRj27BfMk3GMJrPKIMyd4wTy6ictup5TQFDi/s6BpMAqZYYn1U9II7hvaCFz4i0cxMcMCgOAZbHYoUEMSoBc+CP2lKD6GM/mBtVB7nzU9rcFBGOS9f/osSamlZ1Cz5W4v/8LR8I1ADzyrdZ/OibGm6VEr1WrmcfPuAvOtYKX3I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 21:12:17 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 21:12:17 +0000
Subject: Re: [PATCH 1/5 V10] KVM: SEV: Refactor out sev_es_state struct
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20211012204858.3614961-1-pgonda@google.com>
 <20211012204858.3614961-2-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ee9cb472-75ba-2a1e-a88c-ecdb1f3de4d4@amd.com>
Date:   Fri, 15 Oct 2021 16:12:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211012204858.3614961-2-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0166.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA0PR11CA0166.namprd11.prod.outlook.com (2603:10b6:806:1bb::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 21:12:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71774c9e-b0cd-4ad2-b218-08d990207801
X-MS-TrafficTypeDiagnostic: DM4PR12MB5136:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51362A8D2D96E876BA3BA420ECB99@DM4PR12MB5136.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TpB9/493aeNiV+eubngkvGcZMMzZAjxw5AUAjfGLtXQtP1XX24WwQ0JtPsH0wek7REquju72pQtv0av5K+B9ONQRZrRNhbXcuJCPeB80F8UCcLt63XP13CnmmedAL1dVL3/w3BaEQTvJDn0MzRm1TgkwkrZKA9KbsF2acV2/QVD6zdMFPxsQKbIVVsmO5u73mPtJECK+h4FrRTkDm8Fa2p/72H5DtTClZyzx9Dzo3JIlKaaWQHzeQktygc9+DsHeZqADDR0fewQHnQzmdnkx/x19hS0KR1+mLrk7tppOsfqzIEjCDMjYxdePOqoDjLjyIUPpvvE+jSVCDtN/1GgAcBXy9rHPkwH6Epnrwogz3pC039+SvAZzIIO7Am7B5gzmf2q7pndScKZdLz3s4BkXppZ65KGSP6v/aCpofrpRrLOBOLVad/ujTeWHSJSDYAQiGjkKY82G9cJVIIbqKb4O9f1G1USnI1Epx6GAevlfYq2YYmqsnzzO5eWL7+q7wl9hhAy+N5iY/5Ea3UEeJwM896n5pvzHdhuRdJgdxtvNx64zl9LWS1aJZTEiqpjqIwfqQr1uyfvy5Hwqb111GxfPfIat7CG5/ATL0oRcRQP9qegDbA0KPrG28/y9kzkG2mvpfXhncKaAeiwcofMzmCBlgOjyYZpg7Wgtx5JeQrWvQLjYeRDJ7DOGQyFyy2lrwsnnRoS8/Qm6p1CN9ePHkbDNo7q8yvxnHoPJAzRwL0XmTl4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(316002)(6512007)(86362001)(6486002)(31686004)(53546011)(26005)(4744005)(36756003)(5660300002)(8676002)(6506007)(2906002)(38100700002)(66476007)(66946007)(2616005)(66556008)(956004)(186003)(31696002)(7416002)(508600001)(4326008)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vm5WdVRGdys1YmF1NFpzNXVtdzVYaU92ZVhNQm5FQi8vOHZKZFhWNzFFQlgx?=
 =?utf-8?B?Ui9nSUNLVngxcDlFSXQ1T3AvMk9udStJMXY0Rk1LVHFQdlhZeFRRNlZocnUv?=
 =?utf-8?B?M0g5SlJlU3Y4YmlpbitwaHdWeUFWVk5IcVB3Yk95VWxnQ3RCMWVXcEFmcURw?=
 =?utf-8?B?TzhBbWdQekJNSC9OWTRva3lsRnF2Ym84RHM0azA2bDl1UjB0bW1LUFNkd2FW?=
 =?utf-8?B?NVYxNG1kaWxnTEJSczBEaFlSQjE1c3ByQ1dwRGovMWpPRU5Ud050SkFBT0Nj?=
 =?utf-8?B?RTMzbjd1ZlBMekpiaEhZYmgrY29iclVPRU1BTjdtb01lR1BFLzkxNS9xSHVo?=
 =?utf-8?B?c2d3ZFVoaU5BYnhCZ2Rqb3dLc0Y5WHRxeVA2VnVGcWx6NXVhbFNSYW5EMzhU?=
 =?utf-8?B?Q3hzZ2lka1ZKU25OVlU0NGRLeGlpQzJ5R0RFS0xSeDQ2SXFXSm5jNzJNTWho?=
 =?utf-8?B?RDdEWGdZZ0NFenNac2xOTGE3RUxkUWVMeXR3c0JYTVVFWmdsRElwaFBWZkJU?=
 =?utf-8?B?VkZ6SXkrSDJ1c3J5WWVXUUFkcCtHeXk4TCszZzhydk9DeGI3QW5jNU9mNHF4?=
 =?utf-8?B?eWNsR3U4MzhwUDVhbTFRRzRCaWNKeU54K2R5eHB0b1BYbGdVQkVIVkU2L29y?=
 =?utf-8?B?bS9TWGVOSHJMdll1UGpaclhleWVOZ01rT2NuaUZIWUdyQ1NkWWs1OTNPK0lK?=
 =?utf-8?B?SUl3VCtjYzFsaXBNN2pQcUhTOHBic0E1bG52azdESVlHTDA1ZzdZcUFIdEY1?=
 =?utf-8?B?UUNQSEVaeTMxT3NzZmkvZThraWR0dnNpaHpzWGhTRkx5RDE4aXZqeGVNRjl4?=
 =?utf-8?B?czBGM1lnTVVmZllweXYrNlg4L2YyRitsMnVOekdIRFptdG9HRFFvbzByTkZ6?=
 =?utf-8?B?V3dtcHl6UEQrRUxsTUdrdW9nM3QxaFhER0c1ZGdRVkM5ZVY2MGp1NGsyWWto?=
 =?utf-8?B?V09aY1JVSzdYMEtRaEI3ZnFKaGdYTjErTGRhUDlreTZNVkEzdEFyRDZuc0FH?=
 =?utf-8?B?RXJHcElpaDJQa0hyNzBDSDRVa29OZ3pvNGZ3bTdnejA3b1k3S24vMjluTXdn?=
 =?utf-8?B?b1pMMi9VbmJLU096OEY1MEpDWjZGci9DdVVGenZNeUZWaUhYenFqR1ZZeWpY?=
 =?utf-8?B?SWtPVFBIR1VBbkY2UFFQemhqdTNrUVVBaE9wc3pWMVhJL2tvaXpaSW9Da0hI?=
 =?utf-8?B?WFh6djRHbkJiT096QWtnSlp3bjJHOFNBRk5lbDNSb3BrSGZmUVF6VlU3OW1a?=
 =?utf-8?B?OGwvd1Y2ckN2V0NpQzZsU2RWV0t0NlVNRHIvZkxULzA0ZWI2MlRUano4WTlo?=
 =?utf-8?B?SFByV0JkVE5qelVXY0JnTnEvUkNpdVhaZDc3cVJ2SmVUNk5XL3RkRzBVVkh0?=
 =?utf-8?B?Q29mL04vZ0dvN3BMZW9uZ1RWdEdmY3d3NERmbXhYYTZZaUpuZnZGZzAwekVY?=
 =?utf-8?B?dk5zTGtUZDRNMUdibjlBWnkxc2d0NWYvcmZobk1FWFRBajVTRmtuTGFZZVAz?=
 =?utf-8?B?SjFJWldaaDBvY1Y2dVhsbUtRZE0ySXd3NjVwQmFZSDdBK2FLdlZxbXljK0E2?=
 =?utf-8?B?bFM0cS9ORk82Tnl4UzBaT25FUWN4ckpWZmhUdTN1cDIvVWx4RTJSU0Z6TFRC?=
 =?utf-8?B?VDk2WGtSUWJQc0lKTi8vaEQ3R2VtZ0VRUVFtenZBb1ltRmo1MCsyeml5Z3Za?=
 =?utf-8?B?bms3dzZuVjhxZmRScUx5OXJmdjM0YkZYSkZtOFZydDR0UWpkcjdKTitZdDda?=
 =?utf-8?Q?jfL0yU8QsNKHsY8eW0vI8ErJpPvyOb2JyNVTfpt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71774c9e-b0cd-4ad2-b218-08d990207801
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 21:12:17.8108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPQLqM3HGDWH/cpfegs27kWFfvf+SbsYjLFMtDhR4MSANuAsJzZbLJzNN5AHWoPn4L7X7hcrnPwzVXoQhVmv4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/21 3:48 PM, Peter Gonda wrote:
> Move SEV-ES vCPU metadata into new sev_es_state struct from vcpu_svm.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
