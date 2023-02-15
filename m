Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC05698571
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 21:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjBOUUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 15:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBOUUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 15:20:52 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C485A34F59;
        Wed, 15 Feb 2023 12:20:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X69LrnLg7jRw3ho1doE9yHYA2YjOc4PVKqj2kD5qfAyeQPXxXEBJUNzmWh5bIQ6yPbQo6kYTUU8Lg/kKz7jevyz8sRs3UqutEeGoPykkvoRfRA+MUbasFc0wzXaaO6zmj90e30kbIsceSL2JorUX7lVkpX8AkleRvSJ6WcxJfgiOdu1GloeolIF5RtBxHr8UvKQybEITyaSYUbKGBo8yPLMfIBtQgLeZGgbBCuXM1DvWEPYx8gfFgLqr9ph/KICIs3j2Jz6fxp3vmV6uTdvAdzQkvBqwRreTroHgiwZjjVnJCCJZ5jrWQ//JvDuj0KE83azgAXNgLCjdAk2Z4F6qzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/igAStDrCfHG6yh7c7a0aw3mZ+6VNF8Gpo4uPSFOpE=;
 b=i608MvVar1RQ64UAISAntdt0uExzcW08uobZcdIcwdu4mqDo8V7W48iLvQjXdi3Z94xEH3io+l4of9XmYM3M8zY0IvrOcmdTAa6BjY6MpgHuBGdsEJ+55H/UHZajSZ869dE7XhIZeOtwOjvu6f1MkwzQ5265TansDNxNeaXOmDJOhATFznkGpztJtM/DvaunUHCU6MuFCNMPZ9sB0+W4AXTehSS2WzBX8zPbJDkXhoETDQ3eAqx+z7mCaUP7GzTdCb6ORur9FIF8CNtvnV4WiCxl9m6XygFHPnS3R9tBK/JR+M7IsheV4rIlvKL6qjDvibmhsWA4uvFkVmg+hh/VIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/igAStDrCfHG6yh7c7a0aw3mZ+6VNF8Gpo4uPSFOpE=;
 b=LjZp7uiL6WKBOUkcgSNyyLezOzPj1dglS31hwq+ianU1x7qaNA1qTADofKmG3+qY9nmsxSEG5ja2TzWzQFiLyADYAEkGktZ+nt5MjPd3ebzYoGzZb1veomD1wbAx0bCLGz+RPyUabpAqWm1QHW6sHxaa5820a6RRoGhxFHII7qc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 20:20:47 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 20:20:47 +0000
Message-ID: <c653acea-d060-ed81-d3a0-c7379ecb0799@amd.com>
Date:   Thu, 16 Feb 2023 03:20:38 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 3/3] KVM: SVM: WARN if GATag generation drops VM or
 vCPU ID information
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
References: <20230207002156.521736-1-seanjc@google.com>
 <20230207002156.521736-4-seanjc@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230207002156.521736-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0014.apcprd06.prod.outlook.com
 (2603:1096:4:186::11) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a75e680-2979-4317-a769-08db0f921f8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qO+9UdU5qO3sVdZGhUrbWt5Zl6mN595PL1mpQuwu6Lshggy7V81+aXNuLzin4S2CYyAFaMWIl6Rfxf4SJPdpVqnGIunTx2NyR+fpXyyOYCDEQ2BGzg6TOutlWuulKSHd4USHGP6EfLiX/T7R+dHbOaWiRxyIY3cfa6Cro7Rxn17kwaI7lbyTDyMbgHw2j7N6qc9l/vqMiKGq/NBICvar4I40Qui8mkJ8sQ/8RmKMBlQi9gUXhWhPN3YNGuas5WHHL5kbIro6v2Yg+VROHLCO2s8Ooo9KOeTt2OZbSL6X5NpxdasjNRyY1VfKyMLkQwnLw9MdC3qn+BY8LxeQeabXxCY1cSWG+HHA7UiXvH3jywnv4XK0fQyZQ5dnnj3nHZIRK0kpIOvzJnHr03TbgBFQNmPsCKKMEE0TSCNL4H2XgOrOeD691hh0vwRKgBqJ46bN5nKiti2yuQazoTEqtsETBPWlPDx5cDaWhXl29qDs14QjKtyzrdAOC6rLHD3blB8gyPQRbx7TMtFdkFO7Dz9XtfWhrX8L6WAc1Ax9yr3tRlIlvb3hcKvdyQrRCuvhK79Jf0u9QHhY+IwtO6AOe2W3KN7u25mBk/PcVyolFjzUd6MiOWJbzoUdfhEj5I98bb0y3UdEAFJqoaddjjJuBQZ3P3rZ2Ho6DXSS8Ue4LCBGZbGIrkJjUyx1mKm4B7+P3q1GYYyGXU1k530/6INrFOWW9So7mmU+0gkhB90ANzS895o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199018)(110136005)(83380400001)(478600001)(6486002)(2616005)(6506007)(53546011)(36756003)(6666004)(26005)(6512007)(186003)(41300700001)(38100700002)(5660300002)(86362001)(31686004)(31696002)(8936002)(316002)(66476007)(66946007)(66556008)(2906002)(4326008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2pxZWU2N3N6eENaNUVZN1d1OFFCUVhUMDE1NjdlQjdRLzFtRFlteitHUFc5?=
 =?utf-8?B?bnFCWWhXUWVyZTRRaEVrTjRiUnc2N1FpU05MaDluMzVMOHV3d2VGeWdsbEQr?=
 =?utf-8?B?UTlEQlIrdVVtVStuNnQwL2kxQy9TVlZqQU9Ubzl3U1VaZDQ4b04xN0paT0x1?=
 =?utf-8?B?RStEMEhKTC8xWlRhMnJNQmxORGJJNU9rVkFaV2dCTGo2eWN6TEczcWczRS96?=
 =?utf-8?B?K0RqL0lQWVBNc0tNdU5XOVowRSthWFVtQm0rWXdpem8yNStKblVkM0ZNS284?=
 =?utf-8?B?NGs3c2dadEVwRC9QcFlSWmxTamJ3M1hpQ3RMNXRsVkZQOGg1VVVQOVllZzNY?=
 =?utf-8?B?ejYvaDVNU2tOOG5NdnBKSFRMWVNYdldqVWwyTEN0QXpGVUxIUjFiT0hpSGdt?=
 =?utf-8?B?RVpUZ2NCdEZ0WGg2R21IbFl4a041eWpWSUMxN0xWWXB0bzJqY0x5ZVVuNm1Y?=
 =?utf-8?B?aTUyTWRwcDBsQUh2dE9YWXQzcGVpTE8yLzRYTTdmTE9OZ2VHcmhLYlhOVzJZ?=
 =?utf-8?B?QTI0MTBhcVllalFRblBkNDYxMjlEeUMxaysvakRNQ1Q5Tk1Gb3lvc1dQOEFu?=
 =?utf-8?B?d1R6bmVVSHoxVS9TL1QyUFp5b2dNaXZaUzZFYzZjd3FaV2JaTkVtUnlRUFNt?=
 =?utf-8?B?eXc4ek5CWTRtdkNURGZQMDV2andwbW93VmNiU1dySzdxL1AzZ3I4VUEyU2RM?=
 =?utf-8?B?ckljT0EwaEk3VFlDVStjbDExSjJPeWFzM1hTS29qYkpMbG93NXpTSVRWZDhk?=
 =?utf-8?B?cEI2aDdwV01jV1ZyZDZ1VDUxTkNSeEdEbUk0TGJtL01uL0hCRGsvbkxTZU9K?=
 =?utf-8?B?T3NDbFd3Q3NrVmpMcE91UXU3dTJEa1U0YjY2NnFQWVBGSmpjaUJ4RGR1NFF5?=
 =?utf-8?B?dURjUjZJZFdMZHRLckRpVU9qRnBhOVFydjdZdFFkQlJ5TkI4U1JqL1BickpQ?=
 =?utf-8?B?eUoxZFZmYmJ6aSt5ckNrNEJEakJSUDh0S2JQUlZLRnFGT3kyR1lMTWpMc3hS?=
 =?utf-8?B?TERYOGk5U2pnRWtVZzR4ckdpMTVKc3RFM3EvR3dsZVl6dGkzNlEzK0g5cGlH?=
 =?utf-8?B?V0pQY2VzRHc3UnF3QXFPWmYxbWhFQ2cyeFBNR2MyUEtQK2FWQVRMWHRVQWJh?=
 =?utf-8?B?UmJtYWJiSzRYcjlzMUN3ZDdIZGMzTlVBcE5udnY3cWw0WEVkSEZuNDNiYlJX?=
 =?utf-8?B?VXBQYTA1VFFINDdIcGZ5S0JKNkh1YTFqcUxEeXprYzRIUDROdnZYdy9TWk9Y?=
 =?utf-8?B?UTZIajVURHRIR3Ewb2xFNE03WHc2azJ4QlR0b2Y0K285K0tieDhXcHJGRHEx?=
 =?utf-8?B?VmRIQjBkbUhjZWk1cGRDZFp6K1VWbFF6VXpUUVhpc2dETDVsbFZ3V0xBYklZ?=
 =?utf-8?B?NDJXd0JjSXdabUZhY1FrVHRnRDJ3SUFyRmxjNWxFaktNSGJUczYzanJQQjZv?=
 =?utf-8?B?YkszZ0JlMTJvcWNybjExd2MxUkNYRVAwNXVNa2RydTdrZTlXNjkxU21LTHA0?=
 =?utf-8?B?TG9aREhoRXR1c2JBazdSY1l4SU9LM1JVZ1RlejNQaVFqWEVIVlljalFyQjFm?=
 =?utf-8?B?elI0Yjh3MWF2eGs2bGtocXdNRjROZUY4MXdiUlFJamYzT3E4ai8xYVpXTzlP?=
 =?utf-8?B?RlRMbTdPM1JhSUU0QXBqamNkSk9XbHJMREhOYlY0YTNLRVI5NzA0S2FReEFo?=
 =?utf-8?B?RFJwdXMwajJINkNCdHFLVmE5Rm1HWkcrZjhWL1BKQzI0ZSsyNUpjc05DdExW?=
 =?utf-8?B?c1hRbHBhYWhPdUN0Zjl2T1pSbGRHVFpjQ1pacG43aVJUQ3Yvc0R5OUZSaXZt?=
 =?utf-8?B?b2xDTFdWOVgyMDMzSllWMVgxS0dRQjlZWHlvZ0FGV1FvNnhzLzJ1elVHeHQ2?=
 =?utf-8?B?dy9xUSsxYlJvKzJ0N1FEWU9vSVRtcGtEZk9kM3RRZnVBVllGNTdtcXlCZ1RQ?=
 =?utf-8?B?U28wZFo3UllJamVOT1FOenVudyt0dEs1U0cxUmNtMllJMzZDVWREWHFJZFZu?=
 =?utf-8?B?SVowa29OdEJ3NkxlcThYdmtJMFl4azg1UHlMbnlDR0w1ZVRTYW1yVFphTGRR?=
 =?utf-8?B?WkJLQ2xUeC9YSGlJUXpQTUtEeUNuYzVDZWlLckF0dSt5Rk8wYmZ2U0grTGQr?=
 =?utf-8?Q?g7TFdnepnb8OSWs+vOFqUGS9g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a75e680-2979-4317-a769-08db0f921f8c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 20:20:47.5759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSwyCRMOxOp15gqVmdxJE+1l77geLkpSHUFCsz6ziiWp6Qh176TPaZfxurWEzNlfN8IR56j1OoArfOoLOljMmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/2023 7:21 AM, Sean Christopherson wrote:
> WARN if generating a GATag given a VM ID and vCPU ID doesn't yield the
> same IDs when pulling the IDs back out of the tag.  Don't bother adding
> error handling to callers, this is very much a paranoid sanity check as
> KVM fully controls the VM ID and is supposed to reject too-big vCPU IDs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 326341a22153..cfc8ab773025 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -43,12 +43,21 @@
>   #define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
>   #define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
>   
> -#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
> -						(y & AVIC_VCPU_ID_MASK))
>   #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
>   #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>   
> -static_assert(AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
> +#define __AVIC_GATAG(vm_id, vcpu_id)	((((vm_id) & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
> +					 ((vcpu_id) & AVIC_VCPU_ID_MASK))
> +#define AVIC_GATAG(vm_id, vcpu_id)					\
> +({									\
> +	u32 ga_tag = __AVIC_GATAG(vm_id, vcpu_id);			\
> +									\
> +	WARN_ON_ONCE(AVIC_GATAG_TO_VCPUID(ga_tag) != (vcpu_id));	\
> +	WARN_ON_ONCE(AVIC_GATAG_TO_VMID(ga_tag) != (vm_id));		\
> +	ga_tag;								\
> +})
> +
> +static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
>   
>   static bool force_avic;
>   module_param_unsafe(force_avic, bool, 0444);

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
