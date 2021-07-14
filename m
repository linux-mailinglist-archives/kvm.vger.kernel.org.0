Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDC83C8B92
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 21:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbhGNTZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 15:25:12 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:53536
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229821AbhGNTZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 15:25:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZ60j1baSLCEN2SU1gvIMYmq9t5fz3QV0ooOFKvKnscB+6Hi16ZqZiPf2MTMRecEOlTpWJLM24Xc41fEtyzii4MUxSWkFC/AmDu2W8PXjNoAiycOhpO4aUj9Chbsav2oEGvtIPmYv3pRIRQJgNFXNQiUmwJpbDA7YkMRVSpy6QjnCYJoITxZqpHwriP395jy5QuWT9TSqHVK8Yc7wm5Nx+WGBUd6QMsqagTu+UxxkLtaaNXpa3Gjj6Caeccb27EG0IhhnRAfobQBI9uDPt1jUByR3MjEPQglIv0gs9+sOt4ZJIdnmqa4UnLZOx86P++XWAo7rjMUokDbpia3w2t5ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+ENdjkt8ZjVCsuUcaZQ6nZJvwaepTVBjpVrc2b3SqA=;
 b=MXpkL/TC4oPJombDKkaoDshyprO8486I5vXgZRhWv0vVdzzav6ysg43ICnTE4HxrIlNtVX3PsXjO/IlLZThkhbA4J2Cykj0fnhZVvdtlcnxu4P/6B9U+9nghzQnKMQaX+9oxgLrkhKZy0jI00AoILkhSUJlFOk+TlGcMl+RL77meybBxgqy0KCRgh1UUV8o1zJhwtBj5SmBzqZPTJPTVHwL6Ar67YpsnMITBHCng2jXdsa8Ll30aBeTWTvtJJfxzIcVQVY10mNYDV3Dfxcw3wcBgYwlTwmm2w9pnZF5scwqkNu1iKG/zo5HnXkejbeoQfovSvqyMeZHU/KVypUlkkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+ENdjkt8ZjVCsuUcaZQ6nZJvwaepTVBjpVrc2b3SqA=;
 b=yNHpJFCWiSNeK0zLrpbC9UTHtttkZlkkXEdvN0ZrJWQWC88GKreyyqN0wP63oRSUbJJupG+OGnR1Rws/Cwov682QYHpcWL/RgcYAjylI71SQT26wDNPNoiuXUYVJgoIvunnBY56PsSEOi+hPOohvvnHYIWfUnsVb/iI5el2zPp4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Wed, 14 Jul
 2021 19:22:17 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 19:22:17 +0000
Cc:     brijesh.singh@amd.com, Lars Bull <larsbull@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V2] KVM, SEV: Add support for SEV intra host migration
To:     Peter Gonda <pgonda@google.com>
References: <20210714160143.2116583-1-pgonda@google.com>
 <20210714160143.2116583-3-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <5e2cd2a9-99ff-09f2-c391-27c75b4f343c@amd.com>
Date:   Wed, 14 Jul 2021 14:22:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210714160143.2116583-3-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0191.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SA0PR11CA0191.namprd11.prod.outlook.com (2603:10b6:806:1bc::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Wed, 14 Jul 2021 19:22:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3b706ab-d247-492e-2116-08d946fcb160
X-MS-TrafficTypeDiagnostic: SN1PR12MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24485F1B915C90EDAA575B7EE5139@SN1PR12MB2448.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqokrHTjejGmerr+ZmR46Gh/FLeAwFPdf4Uo286H2J1p57oOBpjlaS0AVRPKPnIZIBZm875jgY0m8ftis+48QgpFcR1jrj86lNdoo7+31U/Xv5n19REnqmkTg0nRGbIKBJTQcv+H2MJBCfcLOkBmugg0GGLefUY9yn/i9OkMaPJjnqT/p9RwsDSyYR7UAaABgzrCa4OoIWdbGEMr/L/xX+0kIxeMbNtznnxiKPhHIp9QJdTSOFCojD6Lr84XtbSnbRd0dJJULsKVxx70NMiZ7FnEHmSsDcV5Q7W6prleX8OTtM7G7jTC9vJSVFMKNs0rtc5kn1t2PzrPgaKjmxkzoqYplGGKqcECFlz0Xxp1UI2vUEOB7O6CJLVh8aYry37ZBbHP2r6SV6FrjFRv/y/HaVQoggNhfVqkcVBp6hDkumT9wEZKFOTiSFz3XQBWu4Cu0iWT+Mbbisv1z4EYJ1Nz4bCRUKP38EcYJQHDVemH0jUB/Mars0T2x/JhbspLE3XQ+KUMT3VywektpB3ubgL949TQ/00yqeN6TysrdCMazApQ9AliOuE973Wy3qAR6YJ8rpjI2Elrl5W0DK1gucRVjnKsgW28YH1ZNzqu4R21d+bVfaBBsfq78mR7mCZRh0G5BCxbUwxfC3yUCXm/AtWD3Xc/cWec91YrSGnurPido+YGBuCQETO4ZLnDb89MQAKkTqn9THnTuiSP5XflJgD0FYMurxdjg0Q3dayziGPmlRc1dpB+9GSa3yA61IqWFYC8WYhl27c3uYkEXJtUuE9HLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(186003)(2906002)(7416002)(52116002)(54906003)(36756003)(6486002)(31696002)(316002)(16576012)(83380400001)(478600001)(86362001)(956004)(8936002)(53546011)(6916009)(66946007)(5660300002)(38100700002)(2616005)(4326008)(38350700002)(26005)(66476007)(66556008)(44832011)(31686004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzFuZE8wU3NkbDBTd1kyYmRJVFRJVFhWcTErYWdzWEtzVVFScXJEMG5hbi93?=
 =?utf-8?B?NHp5R25jWTUyKzhLU3RRM2N4eHJtTnV0ZEpsbmJEWEQ0cjY2UVNEZUdJcjBh?=
 =?utf-8?B?TWdRcHhCeW9NQnhUMEV4OWVyVmJoSFlzb0ZZanJLVzZyTWFtdDk0TDdWcEZG?=
 =?utf-8?B?WXROOU96RWtqem9uL0xOeTZUYXdFM1UvMmpPM0lIWnBncld6OEJTQmZFc2NH?=
 =?utf-8?B?ajBSaVBqUEZQSk1GaWxiVWs4TTl6TXloQ1YrdDNSelRvU3F1R2pXWXE0c0lQ?=
 =?utf-8?B?a09ZVUQwQjQwbktMb003RytlanpySFQ4ajlKa1phY0E1Yys0emxRakFYWGsz?=
 =?utf-8?B?SGpGZnRjZkFrRTdRUTlZVTZHK1hGREE3OGRhdGd4K2lRSzRrZmxqWUNxOWQ2?=
 =?utf-8?B?ZmFtVHBQSjRPc3ArTW9zSWpJQ1lIOXQzSXVSbkhmZ25pSTJkSXR5R044QStu?=
 =?utf-8?B?NTNMU3ljNUw4elBPNHdrU3lrVnlSYkNFMWRrV1hVM0EzRm85R3JkT09LbzJ0?=
 =?utf-8?B?cXRsazJiZjN3ZWtkaHV3VXlqRHI1MWFTMGNmcWsyajFZOGF0VFdZN2NwS1dM?=
 =?utf-8?B?M2FzYyswR01ZN1Y3dGpFMUI3MDJ4M3ZpdnR3NHUwNzBrZ29Na1UzQWFZaFFs?=
 =?utf-8?B?cFZKL2lhNTFLeEN4d1VnU0l2cUxHcVRZUEQyakMvTDZ5UkNFL25TZ1NCelVV?=
 =?utf-8?B?SWxQRzk1anVHc0YwYlEyaHJOa0creHpQWUdPM1ZkbUl0M0tPY3FXNTU0MUxD?=
 =?utf-8?B?WUZJZEF6MnVaUmY1eXBzRkpCYk5TNjNDUVVQS3ZEZGw2QU10OW9uZ1hMOXdw?=
 =?utf-8?B?TDB4VjZXV2dVTE9lMS82ZDdyd3RqRVMxOTFTcVZPakJjWjdTcWZNSzRvUksz?=
 =?utf-8?B?UkdRRDJaOXdYcjJLeTkyK2JUbDUrZTRCUmgzTnJZUFBlaFljVmVGaVRQM2Qr?=
 =?utf-8?B?WWpER0pJOW1TcFJYVlZvQlZJOVcyNjJMREplUnFOVFpnQTVIYmcvbndMMjRz?=
 =?utf-8?B?aGJuYUtieGFvZjROTWVhNWtFQ0pYYmVjTWdZa1NMTGRnRS9TMVVubEQyck5E?=
 =?utf-8?B?UHBMcEpoOEdxR1NIQUtYcWdFdWVWOFVXRExhYUZOWGlUVXlJYkN1VWovNm1x?=
 =?utf-8?B?MnNCMDQwTXBzVWNydlgvcmxvMnUxRUtKWkpmN3JNbjltZStyYnVlTmo3MC8r?=
 =?utf-8?B?bnhoU1RKMUR1YzdYR2x3OXVoZ3doZDJYWFBxOUVRRzl5VFRoM3FsZU81VEpB?=
 =?utf-8?B?TWp1WW1WS0l6TkRkeUlZL2NESkZwN0U1ZTBrNVh6bmgzaDNMeE4wMWNqKzBh?=
 =?utf-8?B?NkY4V1ZnVEFGUmRUcXhqWERxazhhRUJwcFBPTERGTzA4bkUxVW9DMVZBL3BN?=
 =?utf-8?B?YUpYL2xFNzQ2VThMZTJwQkZDek9Zb25PaWc3OTNFUzg0S1pXWDZCNE5MQ2NQ?=
 =?utf-8?B?Yi90SzdiRmhQNXRjTDhVL25mVkFHc3VRa3JtNDBMcklvOXc4NHRLdTVnUHdN?=
 =?utf-8?B?M3dZTzgrbE1NcUptYklldW5GZnBMaGhETCtsV2VtQVNwM0x2bXF3M1c3MmVz?=
 =?utf-8?B?aTNoZDMzckxBWmVCUFVEWUNGTWl5azYrdnlxd05MNUNmSDd3ZlBjNkl3U2xq?=
 =?utf-8?B?djFMaG56eFluMDYrVWpwdWZ0ZWZyTERjSnNjWFp4ZXNIMjBSSndvN2RYc3RN?=
 =?utf-8?B?TjNHWk02QUkvZlBJbnBveFpxR3ZWVGoyT2ZoN2I1a3VrR2NXVHQ4c1ZYNTRR?=
 =?utf-8?Q?ecEmoRbXLTi7d9qRAC3K1rtxlRkgJ/divyWVyTA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b706ab-d247-492e-2116-08d946fcb160
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:22:17.5213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsGn9xFdTkws3SvDCiQ4FQJJi4s7n5IyYRI5k6vNfzbQ1B4SpU0mKfoBM+hvIKy038ENpOcC3aXCnBPHb+L59g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2448
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/14/21 11:01 AM, Peter Gonda wrote:
> For SEV to work with intra host migration, contents of the SEV info struct
> such as the ASID (used to index the encryption key in the AMD SP) and
> the list of memory regions need to be transferred to the target VM.
> This change adds commands for sending and receiving the sev info.
> 
> To avoid exposing this internal state to userspace and prevent other
> processes from importing state they shouldn't have access to, the send
> returns a token to userspace that is handed off to the target VM. The
> target passes in this token to receive the sent state. The token is only
> valid for one-time use. Functionality on the source becomes limited
> after send has been performed. If the source is destroyed before the
> target has received, the token becomes invalid.
> 
> The target is expected to be initialized (sev_guest_init), but not
> launched state (sev_launch_start) when performing receive. Once the
> target has received, it will be in a launched state and will not
> need to perform the typical SEV launch commands.
> 
> Co-developed-by: Lars Bull <larsbull@google.com>
> Signed-off-by: Lars Bull <larsbull@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
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

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

thanks
