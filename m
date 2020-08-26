Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724A82539BF
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgHZV24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 17:28:56 -0400
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:12128
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726753AbgHZV2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 17:28:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDFp8UKYWIhbFgr1s6qZWfaFfpVFV5uZ+s94rIyQJvHOHdcx1El0MZqU4nlt9yY4I4iZLAIeXzAIev6ByCYgQC+qQ2RCmYzN7TnqX9d0oxC3WoQLSyAnQWs4fPfnaoWaEs5W+eiXNS2hoYPVmMv5l2imonIJPLIGnjGuEC56ZIfFVOMQ4sC8LH4tTvsfL/Nxrbr39D0CC5tXPGcZ0YEZv2XQidAldM1AIMTvTYyOg0bknSzRbtiC9FINWliqMvbu+TstseYSNyRNfVWsDJy+8P11xHAxDt3OCCMA70MotTkXZhf85TpTWEF+LOGALPP7Ywt+yH993uAm3ievMrA63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRyCNOMO5xHMNKfrmHEw80y023nX5DL2JTW4T8i3S+0=;
 b=ASsO05+DI1bmKhIMZKdY7TmeUEcgU+AcplVD09IU1YulOJLaHF91bmzKYVba3GmsRJ+8eXNm3j74UpevAf47oJLO49w4Nmtv49os81z0hxbTVRWe2boapiLaTqHK4ukem6kjkV0gTZEplnfIvhc5G1TPwmo4UZQU23XbkR+o2RqtloKZEr8tP3wNBJC2G+DGWf2KARbnTVQDC2mlfEvzup2wJtA3RvqhI/92yI8mWpNCWhzB6hAR8kG+UNP3Yo5D8YTnsHPEZ8eXXoCbkWeutnByEMr1ktmqvJ+ZPahNuIkUc+PX1nSbiGW7Ow63dEYkAE3CWa7HYVjgYhSLR9o9sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRyCNOMO5xHMNKfrmHEw80y023nX5DL2JTW4T8i3S+0=;
 b=caRsXu9qPUdXXo682/Kwbok1ihRExHJyin/wDfgLe2A4zyr5Uvtop/hSdE+9RpX57I6aezQrVPHaBhBnl8DGnlMizFEuA22XdXGJKNy63rsiVByGUzP8IXUSgBs7FjcC/YX1kk5zytJFzDTeGkw++Cxq3rvd2mmrqIWBxe8memU=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 21:28:49 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 21:28:49 +0000
Subject: Re: [PATCH v5 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
 <159846925426.18873.12673817778834207178.stgit@bmoger-ubuntu>
 <CALMp9eSHVS+HmbYUMdRgt9gPQaWUGBHt_owDenPOz4+KiDti5Q@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <f7916109-6590-756b-dafc-7976e42fc44d@amd.com>
Date:   Wed, 26 Aug 2020 16:28:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eSHVS+HmbYUMdRgt9gPQaWUGBHt_owDenPOz4+KiDti5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0013.namprd08.prod.outlook.com
 (2603:10b6:803:29::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0801CA0013.namprd08.prod.outlook.com (2603:10b6:803:29::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 21:28:49 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6a96a01-aee3-432c-0dc8-08d84a0705eb
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-Microsoft-Antispam-PRVS: <SN1PR12MB24619A0B736622F941905DC495540@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SNXEfrQF5sMTITSNCUbNODRxtq+OdSbDOLVjDQ/Khwf89XiyGX6TFAvTaBBV4R1w0zcs3ec+M1PClVQhAB3K03Yebzp14Cc8LVcRuJLF10bu7HwI7DiWyYZh3TC8ttHrTPKx6yJEAgIHmTmNrtL55oMP0jF14j5R1ehaw5FnUs1yneh/bAjzNZpcW9MmHsIU7zmOvuXMFPPnLxeCz7sq7y3ZWaodXKl3JqfsSgcT/Kk+ay4gX3QhzW7ytyCEa3sVUzPKRNwLx25BvzrhHV4KlsvMUa0L0OhujMlVymb0vgitb3IP5n7QPvyatBuqjcK/FtYmmFRS6ZHQD+GQ/fuGim5gkn0eDH8H45IwG+ctyR5NVrvbP2o8Sa/ZbVwj7/r75MFXGIxsVvUbWNXlbRUVwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(6916009)(2906002)(8676002)(316002)(4326008)(5660300002)(4744005)(31686004)(53546011)(66476007)(8936002)(2616005)(956004)(44832011)(31696002)(66556008)(66946007)(36756003)(6486002)(26005)(478600001)(7416002)(52116002)(186003)(54906003)(16576012)(86362001)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P/B2MPWXWEonu1bzmN4Gw9aCJqypvRun0sMTDPbD9W1uV6+yzpca+m6oa+iANCMaUSQQCHY1izQIuxv/XzCKprVfMnds3zkHPSnxj627R4mOofd+n8WdGoeG7SQb8XBajMLswx9ZexlrNI9PB5+APMpnbgGtMch4I4HYsNXJyq6pcKIT60xe28bGcC0MeU6o3bh8nlOc8eWC16SehgNYqHf2UgshX9FIp4ks1ztMdB4K9lvWU5zNrpfF5erDZNe3u4LChdaovmHuabfgbKqYu2wPkpIVk7D8/8Gr+sWb97u3DuTvF2s5p70mlav597fAxnHox5RlhagbmYtUQtvWE2fRdBfh1Udkz0dqhOx03xniRR62+HxLlyYI3rr4QGDTcGLVCeJvfDUSZVYBF9u2hR+CK/4QVMnSEYmgti54QuCFfofT6VyCQ8scXQVoSYVu/CjCGxpBsGSkYwjF1p9nhQUADjX4hQQFBfcF/PpwSxNX87ENGTVvLGmL/9gHNqynJU8C/pziVaADAT3nfc7XFbiz7xKERUjT1aIyWQ9tMtDmalzv11E/XfXW++1YyRcGHzaB0tvZMEON42ByW9r6rhkEJaAPMpSMIhzYiRNfkHEJ0f72btG/RO7I5G4qdJMJ7//3h1whcTC0LEKzkth9qQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a96a01-aee3-432c-0dc8-08d84a0705eb
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 21:28:49.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImzICXi6bqTmrZjFoSn46MLToMsyv+E1q1a8UcC+Z2BEj3CWTc5QI2w0qeP7iYhY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/26/20 3:55 PM, Jim Mattson wrote:
> On Wed, Aug 26, 2020 at 12:14 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>> Modify intercept_exceptions to generic intercepts in vmcb_control_area. Use
>> the generic vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept to
>> set/clear/test the intercept_exceptions bits.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> ---
> 
>> @@ -835,7 +832,7 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
>>  {
>>         unsigned int nr = svm->vcpu.arch.exception.nr;
>>
>> -       return (svm->nested.ctl.intercept_exceptions & (1 << nr));
>> +       return (svm->nested.ctl.intercepts[EXCEPTION_VECTOR] & (1 << nr));
> Nit: BIT(nr) rather than (1 << nr).

Sure. will change it. thanks

