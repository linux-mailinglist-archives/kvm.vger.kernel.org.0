Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8273CD6F1
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 16:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbhGSN73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 09:59:29 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:11311
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241248AbhGSN71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 09:59:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2kzaE7dWUO49RHGnemiBchXpi9S6L6wFP3rUTBXZHrN37fxzP5AGwKLcvfJ23BL3dr7hOz8YyAIW1d/iYne86IzKf44YKy1urU7QSEa8loC/dqwaJiSNi3QsTgXmnkrNpYHt/ousbGODa3tzAouFGG/2XhSXe4owp+N6J7XIDICHsYbbY2l1JfPOuO4aZ/qkSfb4DRzyitQO7UCtwxVLDCfK4sEqUx6Ko9sIJ2AVPQ74H2pzJQD34PSeMyrZvzBB5Olo+XSLI3UAInwzRc66QTKOI9NrFh56klNXUaGxuQJn4Si2K2UsfP3XRoMZk3YxcBI+LmGbf1X/745E3eFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6PTP0ELwqnzdHomhtE45Bvkui1MNZF/2tHZenDQVto=;
 b=cIZJjNs061TDPLjl6juugqSp5dqXe0PPfvS5P4BmNm3vpyBFD9XThwdp/oXKlLBg7DdZ6kXW6K0x+OBArNvDcAQxf21GMxJVhwYjwWHqAfsE7QyvTAUs6sLYqNYBkz9iD52iTfUU4iVIUS3GHJbYNzwhjcbyvKgMpP6tMafOWGMrFSvzblJLDHHDPXWNTnyUM7t58nPlkH8bwjN7BhwdsHznJmJO3Hlc+A2nhbCL3Gy+jb4C/+KYflUAgkNaDjEBCDIS5uMqCvaQdEghIT8t9pbfeCq18W1V21MhzzTzw2DVfHLN1xY6n8mQAsFtwxJEHwc6Nt8GNlZE54kZ93ykXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6PTP0ELwqnzdHomhtE45Bvkui1MNZF/2tHZenDQVto=;
 b=ZOGVKffYt+ZnhHiJ0x8M4ELgmhl5YO2+P97dRY6sJlmXjjKoZrY4u1n2xInwu1IY3ysIGJ2bnCFsopc3lXyYQCi4i6jCXQ13Iklzs+WO/FJnXsWB/hPqhSh9WF8U6+/asBaSLZbCe6kUlzm01pkXx3XfzmTuOd4mVXBHWX+0lzI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 14:40:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 14:40:05 +0000
Cc:     brijesh.singh@amd.com, Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 1/6] linux-header: add the SNP specific command
To:     Dov Murik <dovmurik@linux.ibm.com>, qemu-devel@nongnu.org
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-2-brijesh.singh@amd.com>
 <cb98088a-a347-d921-0f1d-d271d740c649@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <15c166a0-22c9-9726-8704-7b73c94f9ad7@amd.com>
Date:   Mon, 19 Jul 2021 09:40:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <cb98088a-a347-d921-0f1d-d271d740c649@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0037.namprd07.prod.outlook.com
 (2603:10b6:803:2d::32) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0701CA0037.namprd07.prod.outlook.com (2603:10b6:803:2d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29 via Frontend Transport; Mon, 19 Jul 2021 14:40:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a986bb1-d764-4618-d1be-08d94ac3193a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44956AB0492DF1A943B20AEBE5E19@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEOJfiYPq8jA/RlLVGZ4H9o400GYvM2F/aw7Jvdakf1DrUL5rImnNLhugTSPFAnz0hA/t/YZHpHCXc9a6UEmf+x/l2GTnCePN8osNeVP7h7iDJCzWzrw8GyzPOwqp7pCbqsMLpMObdgcsQCc4tdNZAlo4hO0JwFAgUpuSlSW9ONuQZHsVHZxWDtspAUJz4I1V6nKDhanp6UqYJor8DVmnV4gsSVTN7bMi+Fk5Y0kOGDRewej4MrXfuWwcUkGX9+X7dz+mC8GFVHqwMWzfUutoxDrV87E+XcMAkd0gJRDDHtu0Lnn0H7idYx54HIF3mTh/TitiYwzhuH23wEJE/TYi3WdOtOHlDbZLMyb0s6qDJ03ufQwEW/k+AdSwCEbk+b/dKCi5VKT1/+xJC20bZ2CgyCjRzdRyfJFfSUsyQwxaLspHr3q7lz9vRZTNARG3RORM7B6byYlpYzUn388MBR3WNgX5xBdpRCg+Cw5iTbEPVYzrnVnMQtSV8wEsdPKnRNwQnkywVpD5WQdzEe9GOqBwe/hgg8io7QetsfnruL9FpBCj/IZ5Nt0eXTwsHzN/iKTdD6gx1OhOs0N+rxbN0Ah66YLFc/0yA9O4SOPcW4IZbTPbd52xLIPhTEi4B3UlnVZ2EKjbb317W1AP5mMQuSOqJrbnedNUYyYU+PLg2VwSeatcWTvXArychWZYLjWI61jhgSFP6iVMSNOi5d7/H8xgpQocNProFO6VcAVBSJJnPQpOqWAN8hIXpsBYm7wgy0J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(8936002)(6486002)(8676002)(38350700002)(38100700002)(956004)(4744005)(66556008)(66946007)(5660300002)(66476007)(2906002)(44832011)(31686004)(2616005)(31696002)(478600001)(36756003)(26005)(16576012)(316002)(4326008)(54906003)(83380400001)(53546011)(186003)(52116002)(86362001)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2prNHlWOGVNQmViL09makt2UlcycHpGOHo0UEZMTTZwWG0xSjcweEc2R0dF?=
 =?utf-8?B?SjM3bEhjcWQ4ZE5rdURpSVlUcVpZSUllTzExb3Erdk4xOUxLaHE2MG8xb1N3?=
 =?utf-8?B?d3ZPK3ZzdVZXVGdGZ2tLL0JvMmVib0NDMXZVUkFxdzlMWlhCV2JxRHRPK3dL?=
 =?utf-8?B?MFJmdGZXYkpUaDJnNUQvR0NzcW0zcUdTV3RNYVArR20vQTZSNDdKeDIva2JL?=
 =?utf-8?B?MEU1T0NidWF3TElKNHA3Tm1ybTJzL1dLeDFXTTg4L1p3NFFkVGVoMHlJQ3NG?=
 =?utf-8?B?R3NaMFNSK295TzREYU1PZ05EMkdpVGRZVnR1L04rQWxIUFdUTjN6VGVXck10?=
 =?utf-8?B?UmJlblBrbkRoNjRnR1JwWmgvYjk4TG1ESUJXd2hITGQ5a3VkRUJiZFBUamFX?=
 =?utf-8?B?eUhkbHdna1V2dlN2azg1Z3Q3eDZZVFdySmxXKzgySWpSVVFXSGVtM0lVZWhq?=
 =?utf-8?B?Z2JOeGRFWXVYZnN6NnRYVDh5L2IrbitIL0xjbkRjRytKZ3ZPVkhzSGZVY08y?=
 =?utf-8?B?Qlk5WTF2MTZzSWM0NUVhQndsZEpkZVBDODhTTzJESGw3cmRyZ0RsbGEwQk1U?=
 =?utf-8?B?VFdLWHVvYSsxZ251cWhMOTB1bEtpU3QzelJ1Um84dTdQMEthaE1lUjV0dks1?=
 =?utf-8?B?bjlKUVNMVFdwaVMzdm1hdjlUVlVqcUFyZEk4aVUzOTJ0UTI2aWE1SXRheko2?=
 =?utf-8?B?cGZXUFRVSU9GbDM5ZmFkc0REZXJDOVkwM0VuVDg4T0xjUkJKT2V0Wi9tNFVx?=
 =?utf-8?B?OFJRUDljQTZ0dXZQamlSZm5xOG90VVhsNW10aDVrQ25WbkFCMkZxT04xOVFD?=
 =?utf-8?B?QVJaTUhYZ1d2dDBpbzRmeDZPNmVsRmJGdGRUVE9ETlF0bFExTExSZ1hoZ1NM?=
 =?utf-8?B?VXRGVTh3ckRkOFBHMm04UnFxQ2haT2k1RDQ1QmVYYWl3Ryswelh6Z09UeERv?=
 =?utf-8?B?TnA4cWtwVkNVRFpYNEh3Wm02QWNxd0FGTHh0bm9KV2RjZTN1RURiOUN6cTNP?=
 =?utf-8?B?STBQNUpJYmdsOG1lUDZma3FQeWpIK3Jza2V6bEZVU3dPdWRhc1hibFFXTmlP?=
 =?utf-8?B?KysyOWZlb3pNanpNczRvNEU5VGxCZEx2U1dtYmYyNG4vQ0J5d09SS3UvbHFz?=
 =?utf-8?B?a2M2dmEyME9TMzI0NGtwZlhEcWZuMFNhYWl1enk5TzNoSUdGWUErRWVxbUlv?=
 =?utf-8?B?ZDJLUC9KcmVpRDFRVklWVE1FbXdGd1paQURUVE03OFNlRzZJSXpVRTV5Wmls?=
 =?utf-8?B?VjNjdjlmS2ZSZUhYRGlIZmlVMEhXYlNiamEzV0NEeDJsaThmZjFoY3Z4M2JB?=
 =?utf-8?B?aTNyZjlPaUROMDdYWlRLSEU3RVZ1NjJySWFIT0tKSEk1dnZMYUxkSEhJNVdL?=
 =?utf-8?B?Y3NCdFo1M0UwT29HOEZvVjlscDQxc1NIV3NpZEhnaU1Qd3AvTVYrQUhpMitM?=
 =?utf-8?B?QjZtQWxPaUpzUVRMeEVnSGwwUm5nWERVVmtVOUx5SHFQRWlmNktqY3cvREJk?=
 =?utf-8?B?bi9CSGYyeU5Gc3JYRkNVVXd1NlNNVVg5YlZOckUrOUFPVzJMZEhxaVhDblkx?=
 =?utf-8?B?blAxMUxrdVhHckx5WXpFWXJrWnBURHE1Nkh5dnNiSGJ2OFZ1M3l2WWM1WEl1?=
 =?utf-8?B?bEFBeThCSFlkNW1xdnBtYXpHZmlQdlBXSzFjY29uN0pxZGlNVFVnOUVNTFEw?=
 =?utf-8?B?QjViTWVsM0M3dHR5Y1hnaisvV3J5UThTZ3p3N091WGpGNG4yNmhxNklpT05n?=
 =?utf-8?Q?vNYfqcnCJvpofOn4/R9urnRiSvY2UDPOCNaSSuN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a986bb1-d764-4618-d1be-08d94ac3193a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 14:40:05.4807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VgMA2M3o/zZvVAoLkkUljonCGLJ+8uF30NNASP1IyJkwWp02hab3mQoI9r9AzXcxyDmJnZH40FR0y1/wXL+/KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dov,


On 7/19/21 6:35 AM, Dov Murik wrote:
> Hi Brijesh,
> 
> On 10/07/2021 0:55, Brijesh Singh wrote:
>> Sync the kvm.h with the kernel to include the SNP specific commands.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   linux-headers/linux/kvm.h | 47 +++++++++++++++++++++++++++++++++++++++
> 
> 
> What about psp-sev.h ? I see that kernel patch "[PATCH Part2 RFC v4
> 11/40] crypto:ccp: Define the SEV-SNP commands" adds some new PSP return
> codes.
> 
> The QEMU user-friendly string list sev_fw_errlist (in sev.c) should be
> updated accordingly.
> 

thanks for reminding me, I will sync the psp-sev.h and include the new 
error code as well in the sev.c.

