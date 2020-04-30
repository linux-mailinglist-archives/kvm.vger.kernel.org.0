Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE11C03CF
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 19:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgD3RWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 13:22:04 -0400
Received: from mail-eopbgr680080.outbound.protection.outlook.com ([40.107.68.80]:56833
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbgD3RWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 13:22:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cb0O3GN67IcYw8ArDdTaYJbPIOPdHDGJYyuwCMlg50/MqJ4znKfH4tRzpKlaf6dfz6LGPyFFDCT1Dj1zjHO2TWkA+mUzAQSP1gk+NActgjpKe3VPRQyODFdLmc0gYD3hhOPEht/w4Y4kQRYnrDvQSQhrksXELYpR77XfSbPq4/wm1KA6QQhQ+IU321icaxq1oV6MZDwcq22x/yeMy//iKY3iyNxXQKSFyqv/3Agtm+IcRcogrG16Dpr4VYZIAv1F9s9wJaWyYe1js21Ipyu+CX2SI8B5BuPcl1vvM2MzcAZZUOy3EyEvEofv+ZgxzeBv5G6y7hC21i8dxRt54j+lhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XO3nw7P+AjQU+IRc95vaogJJcZafqfqYqt9rqaD2dPI=;
 b=Z3USFqxFcGVzSDYJQv6jABTeN6HfUDu+wkP7viX9HG3BvJhj3bkrjxmrdcAeK8uv8IEGTHPfLZem2FkuIpP8qQWI7FFz0B7ZUaXLufbC6wriXSKOuYzvpNBnw6jLWe50jumg3KPdLUDskILfbhutmpw/1NI+pV9AxIHzg6Di+/j1I551vjIkrLjsOIFyZkrEi+W1uvFBfXYRlTxl+8izzDAmGJ35RMz4Lm/cnyk2+q+ZDpcskqKVePTvD4RsEiskI1YMbyPV+LLsNlHztOlcxHOi7I6AMKrUF0SyBeXoNFEL4OghpnBiqxiRPvHf5PIeMCxtFkhzO1ilFy61uhtbjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XO3nw7P+AjQU+IRc95vaogJJcZafqfqYqt9rqaD2dPI=;
 b=cw6J7zDBS6gWHse+D/mt8BqppDr3XJctLfUM8UPBHsJHqRGCb0N5ZyWWupHz+bBbP9bHJG9nSARlJmkfB9IfqFQ/Xrb7U9BLrrIb3du7w9obKMK2mhuQTsu4WELq8Vay+cuYkPxFC7OSASPeBqNQSetNbJNc+ywv9fxBHKJpPT8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1659.namprd12.prod.outlook.com (2603:10b6:4:11::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 17:22:02 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 17:22:01 +0000
Subject: Re: KVM Kernel 5.6+, BUG: stack guard page was hit at
To:     "Boris V." <borisvk@bstnet.org>, kvm@vger.kernel.org
References: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
 <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
 <ebff3407-b049-4bf0-895d-3996866bcb74@bstnet.org>
 <f283181d-b8ff-0020-eddf-7c939809008b@amd.com>
 <2cc1df19-e954-7b69-6175-b674bf12b2c0@amd.com>
 <51d65e72-16de-3a31-1a62-5698775c026f@bstnet.org>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <95363ee2-ebec-ea19-a40f-37c9cde88566@amd.com>
Date:   Fri, 1 May 2020 00:21:52 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <51d65e72-16de-3a31-1a62-5698775c026f@bstnet.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0110.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::26) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:99e1:28a3:aa38:c6d8:dc69) by KL1PR01CA0110.apcprd01.prod.exchangelabs.com (2603:1096:820:3::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:22:00 +0000
X-Originating-IP: [2403:6200:8862:99e1:28a3:aa38:c6d8:dc69]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1432a40a-5af9-4204-b9a4-08d7ed2afed0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1659:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16590B71E3C3E9BDD71A6142F3AA0@DM5PR12MB1659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(6512007)(36756003)(6486002)(6506007)(31696002)(52116002)(66476007)(5660300002)(66556008)(86362001)(66946007)(558084003)(2906002)(478600001)(44832011)(966005)(316002)(8676002)(8936002)(16526019)(186003)(2616005)(31686004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4WHWHkqsVNubkM6WVm0/ZU8vhd9Rthu62+tcW+4NTUVT6TJUFrAeRafPtSC8tI0tqUJQTC3Nvoqn+cgEpOjB5WAT5IxCFsy9jXm8YHSG/sTNjMDAHgoJZrGJY7XL8TS5nZvMVSUJd0RngFD4jL7IR0AEGAtkZVK/yoVEgVe1+GDNEFrhpjtVqJWpfZ0f6U9SNZmdp5bK5Hh+ntF4elfiTFIDVwmHw5wh7GqgMKfnpQE0w+bT9FQ/rMI7EoG8fFnHVplVDV/o8hgs7IiCl9+igah79XvI1Rec632b44mUrC4b10W3Sr3KKSiZg6/tiruWkHfT0l6cMw6mNWTicmk4w8APKYEc/oEx5WJqNBZzAzKzHV+437mHRG9iies6I/XUQKH8K/A3NDOqOchnxxFDx16tpv44yyGuUYJM56oIOAGl7bmkaOq/z3lc7jYIM83wX2+yol2dhB8OF53SAgUlIPm8SlaNVEvrOmGPv1D1HFZM+aSAN9lEBiqY+UoJWEC0O1SGt6rGPYtwNdm/Hs4Mw==
X-MS-Exchange-AntiSpam-MessageData: ZGQjmtT4hpWcqyNA7OviqFodp6sOXTTAxfC6hqMu/4RxOEGnR6NOKXmZOrym4JSWv8SnGLw6bWGq4yUGPdx/HLXomuXNLeryE9BDZ8jxKtgem7Q9T5aOTUHSQLbJOatKNTEdsnEmPZlq+lkieyU39Zx5zvVgrDMo67bNfIvmMaD6YFxKUxm3egUn90B/imlpYYJrCgY/l5Yu12HrEEwEj6snx54SWR5gqnArwFx0EwbW5d2pFiMCP0jViYS1KJ634aqOx115YEnzFAAQDwjFhTb6o8FcQqOYleAa/wkuOqGlDvrUwLNWHAWPsnyBx6KKHC2SeKflfXyb/sXOd05610r/a50odZFpql2FafVdCHVmKtmbmGe1zYqaljuFajGMy1p4DQp5wXJC2UukdI0IfCfTCej/y39HCTmf5P4TYBGGq6KkTz7Rt3EHCXuTgA+Dvw0QBeUXLMI8nfJOj8YhJZ4v3JJ0i2UKfao2+KHXj0c3SIcI+vR35mpHR8TlfbKy7HH451rJBJFmVe1aTotNhlavVTUk1aUW8CcrmW8mQOIaXyQAiCi3xdl818r9azvstGm1MBlWw7QZ8NQujWOzCvj+71+8/jsy1wanUtWzgsvnWXRO1/rhbeD2CQKmnvUm7zjVqnUZNUDcCpEddtDkgci42Kon48OO6Iw9xq34Ai2qJDBvDEGHGzIptxD+w+vy/zVHhxeZvc3YaSsLXa4K+gVMYktTkOlSnxIcleDjo3HwC5O79s2yhqtj8aRy1RdqhC7RLqRQ9DWAwN8hD0CPu8QQ2X/BdAJHcVBApVxklZE9WHLEoBpF+oe+OlTYqJ/9fQXKwZwWNYjan/BDuVtlLy6JMdurCjpPgkZJ+gQ+bSe9zN4cj9YsGw8tgPkbDSbH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1432a40a-5af9-4204-b9a4-08d7ed2afed0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:22:01.8214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOg1NH+GLYbMBayQpXFDBHP7pzVVZCXUDIfcyt+sP2nR5CBpd8NW0AA+7cC6DolraGVZx1zCtn3kJibgeiIxWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Boris,

Could you please also give the

[PATCH v2] kvm: ioapic: Introduce arch-specific check for lazy update EOI mechanism

in https://bugzilla.kernel.org/show_bug.cgi?id=207489 a try?

Thanks,
Suravee
