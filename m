Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5F1C2EB8
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 21:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgECTS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 15:18:28 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:20787
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728843AbgECTS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 15:18:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJ03PPFjeFMKqf6Zd90I+hVkcBr614mB5IkW0C1yCrJkkXlNN1zlFFnwac40ymiGDdcmk1McimsW67FEC66wtqKw2YUetdFpHpSK/UP6EPtgoQAgqc2XzrSb9h5MKzplFh+qAPs12MxkVAK1l9IWr91gC0oe00fnS7gU7a3PAJNowKMbNRTpdETRWXbc69nj+xZBE/hQBGTCL8eAvjSCus3D9DEf0YNGWLR44w61VaQMjUZAN7Aov3tTMYx1cJ8wjIZwbYQAyB/RWGSGebjSr5s5yMjjEVn+udScr65p1AVw3ZkD4hs9P27RkJ8EoANTaL3bq6XYp0EUJYRyGdnuTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMy7DnDJRfliovUluh6hUXFGlryQluvI8RO7eQRwDTQ=;
 b=jMd75E1TV8jW+r06BTShSsznr2svoVVVbCJtYC8HbfeVdjYhpM+VAyaVSYulS41ZSQ1jGsaf4nNq6dt7tzODF7mhNf2kTqBp6AFb8034/ffJ6LYc2S+FNEqrcSROt9J4uu4nHenQvdIW0xeISeNacwTjfOCR+e6QHExgo+293XTQ3WbPLomMMKB5Eh0ouxiTUS5s2aJrZEdjA4u8YmLYe+X0/zjAelvPc//J17B3gTr8tEMKFFHSxEFefhgnG8KiYqGICY/jhecbHZdnk2liYvLjdvCxub2RTTZxTMPZYZFYQnJnaOWAgIP/5lMpw2bkfV70YgtbGut3apyhpb4OeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMy7DnDJRfliovUluh6hUXFGlryQluvI8RO7eQRwDTQ=;
 b=bstM6LGqOi8MjTiZWkztC40I6fjE6Hoceumr6UNtfFGMuN5tXrjEc9fitr60mjMbNYc/ZaKQ660KBHcCkP5MNxJbqGuBvXC1vzARSM3a8NL4ru6g+98DKUqgTPp/eXrWrFVtfRr96bVHjSbbbbJJfK2+DDm3psfJMZqfEQbTz2s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Sun, 3 May 2020 19:18:23 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 19:18:23 +0000
Subject: Re: AVIC related warning in enable_irq_window
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
 <27ec00547131cc0e0b807e94eb30fdcff5c1cb47.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <dda0de57-b891-9e30-b2f1-561c5e04ca39@amd.com>
Date:   Mon, 4 May 2020 02:18:13 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <27ec00547131cc0e0b807e94eb30fdcff5c1cb47.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1P15301CA0003.APCP153.PROD.OUTLOOK.COM
 (2603:1096:802:2::13) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:d0e7:1811:ded2:5c1a:f796) by KL1P15301CA0003.APCP153.PROD.OUTLOOK.COM (2603:1096:802:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.3 via Frontend Transport; Sun, 3 May 2020 19:18:21 +0000
X-Originating-IP: [2403:6200:8862:d0e7:1811:ded2:5c1a:f796]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4aa52cd2-c52c-43d9-e91a-08d7ef96bf9a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:
X-Microsoft-Antispam-PRVS: <DM5PR12MB18835E52D4A97B91944196D0F3A90@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0392679D18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eHa8uIWEzTTqaQuDlZ+ajWT22YzPn4oqR2MfhvxbugAj/GVuH/3I5jDqngnK+XVTMu3/viu78qTskoIEBHO7qSm3aJ83u/ZSRJvmBDfQ+S++7UzAPXS/xki8aiHUW/YSHI9Ed5VZ+GTUcxXxZoYG3KADR0F1hcQTKLwU5lAnkLk+FQEGmwQKcj2LJJHqWB351g88nQ2IC62aeDjt48qVgg0FOUhL1weNEtnXwYkrje1+hgSiRVQxulaI/NXCWSIgk0tXwTdqZiAbebYl3/5e/PjeNwue/Nf7gp0S27csjy1FVUKhRguXCzM2IcQ80+8W5uSjsV90jLzB/mCAQIvtWs3Jcfk21H3sFOHqnLlYqPg88jptvgifvlCBZaa9nGvgUvEtb7fig6NggOPJkWZsD1UDD4Cb7sCMdCgLQ+DmZHzrQ0F/Zs51qDTRm5ttb1Ul
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(52116002)(110136005)(36756003)(66556008)(66476007)(66946007)(2616005)(53546011)(8676002)(6506007)(8936002)(31686004)(316002)(6512007)(478600001)(31696002)(6666004)(86362001)(5660300002)(4326008)(16526019)(44832011)(6486002)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ALGijgxD5FTHmBm3RYPF7x5vsRzz+ukXmRlg6Z0c06eOHrCFM/b5sVD/1ZkfxQAJmm2rga4ZKRk3YqrpW7hED6A9nTw67IyOq9iK3STvb/eCJ/AdL0UJfKTO+jxh975ZKTLjfXmm8g8rc6hkjdGOKOZOJBcZyhxXIirKfTAuak6VnLd7YjKqhChKqsKOL5I8ZFgZJo+/5/vQkEdKZ2bR4TNfqUMkit5ut4vMcMC4QiIih+/S9pWlczKqt/zq6YO4b37BDl+z9ZylhAiwPvCq5jVqG2/IJm3T/eCG9LnGgYqv3BJ49V49fGoLzPpIdi/6HWBxU37AmRjz9SX05cu8ySWpbFNHe8Vmbq8awQMqNajQ0IFYuHBUjN8wsJmXE0f1RUc8McL1F3GaOotVYUicuM3+Paq0pZWmpGhHNFw4hFd1hcRNg9xSOHHtVYT8UHy4B6bmWGNXfDtroofOXqEhdf4R6ws2wumLEbMe7a9GxAbY2ioYS1uaLn4fOn3CFD0k44DVbIt7mn9ah3eIu/QwxdZvRqLx+dVCFpWBrrbj00LguwCtZplCSiWCrI6u0A4T/3um0x7OW9eNbBa7MCITBe+ua8bTYAOBB1unPxqX2TUr4ff17zrKbNshj95e2xuvs7ruqWPTfbzmrIKtgiWtVsMopGTCQmDaGMBoYltI5i7EbOK1FoRFJoZzLqNlebSJG9vyq6DMSLIKnfnc/8cp/j5olxTPIUawmRdQVYM+4RM45v+smiy3apji7nQbDLoTjp/oEM9pZzGcvLbeAxTlCsEJJDhYk4IQpfJyztkw75zWXBPwczc/ZTIX+Wc0nJx0+42ipny3nvAPVPKBsZyGV2NlcbNzFzUD+PxS5TlqI3GIigf7aM9L7TcArnZYCsDV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa52cd2-c52c-43d9-e91a-08d7ef96bf9a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2020 19:18:23.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNltNIOn4OFeR7nXmt5o7cnGCsdZmG0Ee2yTmL/SkV6VN4rHOcIpKg8a/Rxuiob0lXcJ+9ZbpD5FhEaglCtk7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim / Paolo,

On 5/2/20 11:43 PM, Maxim Levitsky wrote:
> On Sat, 2020-05-02 at 18:42 +0200, Paolo Bonzini wrote:
>> On 02/05/20 15:58, Maxim Levitsky wrote:
>>> The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
>>> kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
>>> however it doesn't broadcast it to CPU on which now we are running, which seems OK,
>>> because the code that handles that broadcast runs on each VCPU entry, thus
>>> when this CPU will enter guest mode it will notice and disable the AVIC.
>>>
>>> However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
>>> which is still true on current CPU because of the above.
>>
>> Good point!  We can just remove the WARN_ON I think.  Can you send a patch?
>>
>> svm_set_vintr also has a rather silly
>>
>> static void svm_set_vintr(struct vcpu_svm *svm)
>> {
>>         set_intercept(svm, INTERCEPT_VINTR);
>>         if (is_intercept(svm, INTERCEPT_VINTR))
>>                 svm_enable_vintr(svm);
>> }
>>
>> so I'm thinking of just inlining svm_enable_vintr and renaming
>> svm_{set,clear}_vintr to svm_{enable,disable}_vintr_window.  Would you
>> like to send two patches for this, the first to remove the WARN_ON and
>> the second to do the cleanup?
> 
> Absolutely! I will send a patch very soon.

I have been debugging this and I have a patch that is supposed to fix this
(instead of removing the WARN ON). Please do not remove the warn on just yet.

Thanks,
Suravee
