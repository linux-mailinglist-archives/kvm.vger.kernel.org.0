Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224C22D1D7D
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 23:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgLGWik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 17:38:40 -0500
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:62457
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727785AbgLGWik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 17:38:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N52ZQHCJ55NCsLxUSD8ESC9XVCqFZ5z69hlVqvnWOy2EkvaY1vjJyt4JHU8fexQz4IndfwmbOloIeeIwfZq45oifjN9zFupDyAVzHACWkwP/PCg7E4bpvHZH+PLHWPllgT0MpFAP9uAr8L1ra4/Cqsb0RDV8fYNUW8/zJW8IjNitCG4f3L5N0blxmou/Za+5SxLlACegFVUdyzWle+HlVDpmDN4HsuiZ49DFvPRp9O9pJkmH5p+z68gLMz763wrDPMc/TJwtW0GnH2Wzq8x4wBLDwfUHUOgoBOtAlb/oUsNrDWuHfYLsXJvIRL7J/N2MW7hdSe5dCqjsO+Fi057e3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEQ0wqp9bp9VQT35GabU9pffixk7osnVtkmYsDMiSjg=;
 b=HJ8SD7tz381Vo1LgkMTkP2uiFTtBil64IGaNcJeFQ6catISCo8GgUYvYnVXZvkVvIIiUopQZEoUl84qVBEaMH3ePHFnDT2AmQSeV12yN/jWKfjyJgGfafjeHSAQI/TbclF/MudWTORaV/oWMOifsAt/a7BrDYmIKUc2gTej6s02IsPb919tkJEVU7Jqu/6t6egwb6/zxZiI9uMMKtx/xj4EGN5ZH3aZe+FP8OUEWrlsDVOM120r95Y81FVJXIEI3wo+0cWPPhOdBTMNCsT0HgT7IIwr3bFQp/e+bJwbG7cFx2tI4GyKWmcD3l0PXJ8MqNMd7mDUY3+JCPilhQOrkQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEQ0wqp9bp9VQT35GabU9pffixk7osnVtkmYsDMiSjg=;
 b=qLk+3Rn8A1AU765csXPukI//kMRtdwuL0zvSwFvKtT7cJbRWe7EusYNbo6YzF5kNbypUk0t84abh/TcNZ6afXywwGplOyzhw2y80JDd4WzXqFH2DM64RzkONYJfbh8KiOxJHRA64f4o7ZN2N5s7zgtlZ24fFOsbdouISCzB5QqE=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2624.namprd12.prod.outlook.com (2603:10b6:805:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Mon, 7 Dec
 2020 22:37:46 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 22:37:45 +0000
Subject: [PATCH 0/2] x86: Add the feature Virtual SPEC_CTRL
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
Date:   Mon, 07 Dec 2020 16:37:42 -0600
Message-ID: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:610:60::27) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by CH2PR14CA0017.namprd14.prod.outlook.com (2603:10b6:610:60::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 22:37:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c59130bc-2708-47ff-c9c7-08d89b00b7d1
X-MS-TrafficTypeDiagnostic: SN6PR12MB2624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB262488E28B70D62F8307E0C095CE0@SN6PR12MB2624.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c18iB9MIl2TbT3iyCC6YDC28IfS4RA4uiVgR4zN+vvh/MyLW4bdF6Vrgl4tynzwJqYI9exnC4NG2P7/8lNC8RvLucUdnyXqGYK/qiOlbJCwk2rpuOBpdwhyUt4rZTAe8NZddye6BoMf9nMWKxndoSUwyNLyrcmoqMlkYzHWD/ID1IzE3t0A6sdbgwFKCvaIojK0Mh6zPKqe1b4btvCEU4PNtF99YsRJkI1qmCx1A/0rKn8T+QiFbmym7WHqaZtTI8P6vpMGpp8WU1jMydCQe55WaGvFER2YKi/tmw0vPze3VoaIQi9/RtBwH+w4UECXp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(7416002)(8676002)(66946007)(5660300002)(66556008)(86362001)(478600001)(66476007)(83380400001)(16526019)(33716001)(8936002)(26005)(52116002)(103116003)(6486002)(44832011)(9686003)(316002)(2906002)(956004)(4326008)(4744005)(186003)(16576012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eWZuYWJkM3k0NHZJQzdHcDJNOE5QUjlUNEFEbG8reXBhcmx6WDZtQmFjL29C?=
 =?utf-8?B?VzRQL0o4WjRJUzJad2QyRTB1R2JkQi9wcU5HbXBZMUNlT0g2TDkzSkp2c0ln?=
 =?utf-8?B?aDJpYjI0ZWdmQXd4ZGEvRzYyNWVtWnRCb2haOGhlanBzY05Xdk1yQXhiS21U?=
 =?utf-8?B?K080VU5iamtxdDVEWFVqL3ZFd1l3UHMrK1NPU3k4WitjeElIZHhtZzJDdXZO?=
 =?utf-8?B?RFBKTStGeTNSTG05dDlZV3FZQk9Memc4Q29NcjE0Wmp1ekg3ZytJeGVOOEQr?=
 =?utf-8?B?eE9KTDBVV1U2VmhjSVplNFpnSW5kSTRPcjd1OHl1Qm5GbVRKbW9FaDBObHRF?=
 =?utf-8?B?NDhpeUFsY2s0dDdLUUVMWXZmOUk2T1gzWjhuTGlVNFArV1FOd3ppU2hKV2No?=
 =?utf-8?B?UjVpaFFZTzJNRlNqRzk3VGg2cm9jU3dwNjNoS1JXaVRJbDFjazdFSzRCbER1?=
 =?utf-8?B?M0tlQ3JkV2xsNUtFYUdZTFk1djZVZTdiNVk1bE9VL0JhS0R6RDJqMGRob1h6?=
 =?utf-8?B?V1RFMkVZeVRXMy9EM0ord3N3MWFiWUlJYklzOW51b09RVXoyUEpqc2ZZdnoy?=
 =?utf-8?B?SmpMbmtCZDY3T0VWWkM3WFdBYUE5L1hYUSt3a3NwK0RXQ1Y4eGludjhLV0Yx?=
 =?utf-8?B?OGM1TUFiZ0xOKzhqL0w1M2FNYUk1UDVpMEZMNTNSc1ZMVjZONTdhc2dUOGVK?=
 =?utf-8?B?cmNzMVNLNk4xN1FCV2JpRmpOVENBbGxwSnZsMkQ0aEE2WXhUTVlDMzZLaGhn?=
 =?utf-8?B?R0dDMFRXR1E2ci94NFN5WEZrZmJvNmpvWkxTRVNnSjUzaFFYbksvMk9zMUs5?=
 =?utf-8?B?bmZsdDAyZVZjM3Q3SHdVVVJwNGlNMVBJektYZklBYVdaV0Z0a0RMNmlnd3FK?=
 =?utf-8?B?WHdQbHNlSmduZlllY3ZqblpqZnlCQWxCUjlqaWduS0tXamNlMExBWkJNRjlQ?=
 =?utf-8?B?Q0xCa2JQc1d0Wnd5MnZWUnJrN3pWRXlZM2ZnVXg4eHdmKzlVTjA4b1docjI5?=
 =?utf-8?B?LzVuOXozc0R3RHN3clUzTE5SaFlvZVNIUEgwbkJ4a3ZmMXNiTE52WEg1ZEZO?=
 =?utf-8?B?OW44L25wbTdNSGRGaGd2emhwTmxMUDM0c0N1NGxRZjFMY085bDlhcENoWnFt?=
 =?utf-8?B?YlY0VkJEL3dyQmdhcXZWcEtDK05KM3Jsb1d6djg1RHB4MjVQMEhwY1lscDdw?=
 =?utf-8?B?N0hYektLWGw0bk96OTBRT0JyWFdqbWRUcEVQdDZMcVpqRmd4VzFEMUoxZzAy?=
 =?utf-8?B?Wm9mMmRqaGlpK1M1R2JFSWJIaXZOdjFXS2paeE5xWFpBZ21WSU5ocVhwS0xD?=
 =?utf-8?Q?D+B99xwCaD3nXgIn6yld36zWYku9k7rla7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 22:37:45.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c59130bc-2708-47ff-c9c7-08d89b00b7d1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GsrYGQ0v/a9LFFjy6s0LZiaF9etV2IqhhDohHxJpHUhR+SH2tx1miMfcnB66Ikt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2624
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of
the SPEC_CTRL MSR. The series adds the feature support and
enables the feature on SVM.
---

Babu Moger (2):
      x86/cpufeatures: Add the Virtual SPEC_CTRL feature
      KVM: SVM: Add support for Virtual SPEC_CTRL


 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kvm/svm/svm.c             |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

--
