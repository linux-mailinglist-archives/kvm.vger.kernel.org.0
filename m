Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C24E1D1A0C
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbgEMQAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 12:00:08 -0400
Received: from mail-dm6nam10on2050.outbound.protection.outlook.com ([40.107.93.50]:19892
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728692AbgEMQAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 12:00:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixEnKjphisl1CSN0lBQEL9VhF/qsjHOA9xGdOkt8end0e8HHC/V1buS3JcW8BAJaDesZZQIe1Fb6DRpXP5Ej3uGm+kTsmdlHkH8iZAxhdN7oLwn6rlhcuIuAsht7PmhJMvSHr9ByOwMuFcdOeGXuRr0f+F0PgjnsegOM9janzzzqxvhskyWvvtWjWUbG1vJNpoCSnriNVECOl/N9fKOE9ovSZmdkTj+e67nUaxn6WG5lZmOjrxi0QOzf3FbOXDnEIR24D+DtKPwv6Xi7/4bLgxmqhBLB23bw424S1cgRooRnd2c23Hf2RZyDM2GUtWme4WmHscNsGisL7UcchxazEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XujP5eAhFBUmlXztzznPLZupd5FaJsEYiB4b+z3j2Wc=;
 b=QrqfiPtUXs3VqOxdmizKK+W4PFGaIWn3alqJZ+BlNSfXvWRQfm/70jmiIKveuXCrhDqL+4OScUNa44SugCMb5LhOvPF+h7kJnKdXuESsGQ3Um3irLhVKleM9Xjvnx/xugMQi9yoWqg8vi839EJLL382sYr5gXQmC4hXLQjQn1+IBgsSXG9tj58NF9GQcJboNUtUnBMQ614i6Cg5Gg0AGMKh5Jpt38hHxLSCXfgWAkhXH0JBIcyn0dB7WvdGLHRDvqmNmSWH5Mgte4aKnloLVR6L3CiDMfhEBUdTDwwsozUyL/HS4JX9EEo3QGg0Kpu7urvljtnpXXwB5/j6aw03lSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XujP5eAhFBUmlXztzznPLZupd5FaJsEYiB4b+z3j2Wc=;
 b=La8D4OSZtPCz9mGMRB/9rHu04EqH/sfxM2Fy4yr0KKq5ny6RyPC0olQRWhUPCPPkgEdB5Nh35duRNjrHLKhEa6IKe1Vhkf9O2AuXIX5wNuXf7si07Vnord1z32xkONt7xEyy3NKyE3pX/K4lcqhqkhfZxeZkmrqKInD9R1im+XI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2400.namprd12.prod.outlook.com (2603:10b6:802:2f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 13 May
 2020 16:00:03 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.3000.022; Wed, 13 May 2020
 16:00:03 +0000
Subject: Re: [PATCH v4 0/3] arch/x86: Enable MPK feature on AMD
To:     Paolo Bonzini <pbonzini@redhat.com>, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
 <8cef30e5-5bb5-d3e2-3e0c-d30ec98818da@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <a60b3f06-4db4-38d9-b3aa-bcd27712e42b@amd.com>
Date:   Wed, 13 May 2020 11:00:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <8cef30e5-5bb5-d3e2-3e0c-d30ec98818da@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:805:de::18) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by SN6PR05CA0005.namprd05.prod.outlook.com (2603:10b6:805:de::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Wed, 13 May 2020 16:00:01 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba1f4abc-0eb6-4451-87ce-08d7f756b299
X-MS-TrafficTypeDiagnostic: SN1PR12MB2400:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2400E0AC7E36DC6032DB637195BF0@SN1PR12MB2400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Asz1zubyysV9XvlKLaE5N7wDIQ6F6G3Q19bx0buYoccEAzR/aa18wlAggIvR6T1prj+UV4ROLJzVubehybb3SEpsckcVWMI3G9fCt5MkBXWwWQajctKevMpvuP0vSdzKd2X2HadQHnCfbOkSGE0tsnCR/yVgMehqSamTEEbCd26JmjtAMkD2I8HStw7aX0roodKulGMppKsNe3IGQlbjUmaLONCm9S7iKqQHIBdWF8BQ3f6ngAtuqnsbvPFPoRZ4zLY3YjtWbutOOHUfEIHlCSop48NO9QIkW1bsoKq9GRjrbsIGN/UzBIpjAn4D6CxhPF1ch6efUX17eHx6XUOHlWMZKJQDyf3EfsBxYLFgfHIPXiIEl6kCbimjLnF3226tbFvjzum6AxQ51f90MpdqdVddNS+Plo6HECycojFHcSYidQgGcQ6fazl1Ms+u8qEHjSOid8sL0PeOS09jAY/FLKzRpAB6d13ZCOw9v/MfZ+E84wZsuAqrQ5+StiE9eITMVb3syIimRzODlv9uWrN6635c3JlUZMgjQstlbk3+D9SOXkF9y+hkAqRAckmgfeBO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(33430700001)(956004)(44832011)(2906002)(478600001)(8936002)(66556008)(33440700001)(186003)(16526019)(53546011)(8676002)(86362001)(36756003)(4744005)(316002)(16576012)(66476007)(52116002)(26005)(6486002)(2616005)(4326008)(7406005)(31686004)(66946007)(7416002)(5660300002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uZMxNod/Hk+ssxe7PZotG/qPIzBSe6ZKTtcYVkzxyhCWErdtEvyP9hSvFRevRaA2/5s5WGR8iAGi0xf/d1Yxqy5aH0/MRouCRf+IfyI3Hfu0YYbiaEYD17ZPbosAU6ieA4jojwGNvut+UFu+nPgTuJSLLTHIJETUiXirExFzvtAIqhoVez7zZ48G7BNGpylr92antjPXeFX3X+ddMx0mOJShne/kqt4Ryt+GEIdehCx/qR7TBD0sJXY/nFIVXbFtddW/P2rRqjuoFPGsafR0xiW7T6kpn4H8nqcA/qhBUvoSt4p/aK+nVlbec51LcEBt4gY6B0ODRgPNyxnRkVIJ/G5W/PqlXzKU98+qF108lX3qB1ZxM4VQj6D/w+kUfLY1cfUBJ+f6pzDVMbG6b3//aXVe5deGl4gUaiENg0Fdk7tnhYgVOdxpc5TPBiSn/z43MTA66NhF8Wjn/jCcOr4ijffhT/cel93fx84WERejNxE=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1f4abc-0eb6-4451-87ce-08d7f756b299
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 16:00:03.6366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwABPHGXrpVdiyJYuzS+KPWmYErmJD7f6L8INqLNW9e/FqxWdMAjAQReCEabsLqL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2400
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/20 10:35 AM, Paolo Bonzini wrote:
> On 13/05/20 01:58, Babu Moger wrote:
>> AMD's next generation of EPYC processors support the MPK (Memory
>> Protection Keys) feature.
>>
>> This series enables the feature on AMD and updates config parameters
>> and documentation to reflect the MPK support on x86 platforms.
>>
>> AMD documentation for MPK feature is available at "AMD64 Architecture
>> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
>> Section 5.6.6 Memory Protection Keys (MPK) Bit".
>>
>> The documentation can be obtained at the link below:
> 
> I'm queuing patches 2 and 3, since they are do not need any support in
> common code.

Thanks Paolo. I will just resubmit the patch #1 addressing Dave's feedback.

