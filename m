Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AA6749FF3
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 16:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbjGFOyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 10:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbjGFOyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 10:54:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5621FE1
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 07:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9ZyVDfn1Q6MDF5G4OxWs6DoLX8SEr7zXxFU2u90JdU6dFN1ume3r3WqruW7+H0Ip12QBB8FxJiy3OELyOuLbLUTrVhqtgU6xPUlLNHOwCmi37ou9kgjzY0koPzFzi6O/b3129w3n2IhsRJJhUt0Y/LlkI9WVGiqJ/Ao8XiGuBUGRNlmyIUUOqw7LnZH9jxgl2dJaS+dkXFsQRVhWHYmffcylcj5YuCj1f92J29nfpDpc9vpOlOPjKs2hQwxH/KJHH7CJOl+Oby7hMXaVPIiWsIqHBg4vLT8Z036h7b38jY5XZ40mx7cprinwFvp3CeE5bekMtuszuq22cmbHTXR1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=791YcPgQ1FhSU50xSd0HY3bCTmFLKMRt+YWTS2n8Ojc=;
 b=ksqWZDbpIgdtZjrik0jPraxnBIsdz/OIcDarfNYz62WbSbDztM+XdD75JiKZvCeVKPy53gBgfjZbOBmLuI624OU+YWeVWMe596bdVkBzknu7KoKdGg1ueQQ06Hx8ubAMRemh1W7MlyBz/0EhpWgb4QaiIpVSiAu6BNMcyJSP9E0DTIA27dOmEbEdJ6fbk0pEOMDmNnccCm3OeqwZVg55rbC86pdOw2hoTpPelzyalJi9dHYnSWIKc/FUSbyNEluvYk8OAkmSCm94gUBLqiQ/CLcAvqRVrjZsNiy7JYWVpxzm4YNmRsI7cSCEzXsskRMHQFrNgPs17hzZubgF0icqqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=791YcPgQ1FhSU50xSd0HY3bCTmFLKMRt+YWTS2n8Ojc=;
 b=fLAJ5rA00jDxdYNuGuRNU7zddMdbMkn+RPhJUEt9UZ9L6pbdJ4tp7a5HGhrSrq6lanMJDtIQDJEq3gS5RjnKz84BCscbOQkPOZVzrbTDUd4A3xqmRvsYK60YML/qa6b4vk2dp+GvK2FmPM/TZkf3YzcX77IBOTpDsiAAfF/F/kc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by LV2PR12MB5848.namprd12.prod.outlook.com (2603:10b6:408:173::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Thu, 6 Jul
 2023 14:53:54 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f%7]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 14:53:54 +0000
Message-ID: <8e8eea5a-c5bb-c460-0e80-0f769ec9e6d8@amd.com>
Date:   Thu, 6 Jul 2023 09:53:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        kvm list <kvm@vger.kernel.org>
Cc:     "Kaplan, David" <david.kaplan@amd.com>,
        Jeremy Powell <jeremy.powell@amd.com>,
        "Giani, Dhaval" <Dhaval.Giani@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Ashish Kalra <ashkalra@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: KVM Forum: Trusted I/O BoF summary
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:806:20::8) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|LV2PR12MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 015692f9-7be5-4b24-fcfe-08db7e30d1cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhNoeZZqcHXDNK8UqBRzWrDNtviFpI6g3c5JKxEvoxnMQKuE9ObQhR0DzHxKwsjV6FmaLTyks5U7ExicJSNHZvGIP8Kdptl6A7SYlpJoYnmfQ1ZyNgjZRsvzWOh340umqE93uNlHpbb09rNuzS+PS8UJVrmWPdxAjNtzUUOIHxVpR3OK/EzMbbhEvIDAhdMZ+ZerBgcBlIo3GerPirWW8QkofkNnbXzATjOLliSM/nQ7Ywv/3moZo+vOVMCa9V3Uz9W2VDhk+xewBsXx4FMkR1hLnlD0EmGg9zYnQ6whcAcrebLOzOH8O4iUXIRCyVnX6k2u9lSrmaBetcFdVJIinXL/o89XOODNMxmof0sWOI8QuCy9oTiVzLzLI6GXu+pVgNB+4rXAjUDcUOqWqa+DVG0YVS4DDvh9Z0wUXdKmiyZwsrvY/TNtC6SCGfqwtDzxZoyqgGw8pE6Opl6306dRMJCAJx0Q2oLRr4rMk9HEBIhtUOf1GqAg/CjwE+agw24PhNpY8QRqWcbjAAZAYVYOmpfwKbblk1n45pdHPUX9Zamr7h/kW9oJM7e/Fc0sm822VhNTWdx858K8CArC8EYad13Zuf1kb++Kmi6x812fWasaW4AKaKkb1N33nUvBJoie1P3fJptBtqpd6wDikfblhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199021)(31686004)(2906002)(66556008)(66946007)(4326008)(478600001)(66476007)(316002)(8676002)(8936002)(36756003)(5660300002)(31696002)(41300700001)(110136005)(6512007)(86362001)(54906003)(38100700002)(6486002)(6506007)(26005)(2616005)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUpkZ0JocDZpcEpiSnpUVE5BRmZQSnVMUGRKdU42WXZVb24zTmdxQnlHUmhP?=
 =?utf-8?B?cTJGUWRPMWYvdm5HZzFiQXRIa1YydW5KWGFYbW9wZ2hFWkVoYUtHK0p6MWtu?=
 =?utf-8?B?c1I4cVlWOVYwbVVmRjFzT1dpU05XZ3p0VWtPS09mQ2hZUlEzUXVPZFI4bUly?=
 =?utf-8?B?SkhmcUVvc0JDS05TQmZxcjZHaDlTY0ZJSkJ6ZnVrczJHN0FUd0ZYb1hFS0RD?=
 =?utf-8?B?K2M3WTdtU2tMVVh6V0g1MFBwakFsZ0xubEVvdlY5ODlVRHdNZnEvSi9zb3dF?=
 =?utf-8?B?cExybUhCZER4OTVYK1RoMVV3UGIwczBHcnpMckJpaFRtbGZ3VFA0R0lRa1Ey?=
 =?utf-8?B?dHRBSEFNQngvU0lGRnI0WHFGL2l3SEhCR0VIc1p5ekZmVTFQa2drNUFpa2Jq?=
 =?utf-8?B?WEZ1N250djRqUjlIeGJteXZIQ0ozL0JvR3NKTGVnVm81OUNQdklnbEVFdTF2?=
 =?utf-8?B?REoxOWpsemZEc0FuRVlScitQYytOSmVhSkRZQUVuSUFsTDVFcDlETjR6MG9W?=
 =?utf-8?B?THB3MUxWZjRWd3RzeWo2cDlEazVZS1o1bWIyakkrWlhTM2RJdHNUN0trRGQz?=
 =?utf-8?B?TVdtSmEwaUVSUmVaeXIwenkzbVlJNGk0RXNqVklLdzcwVkl3aGdtQUpHanJh?=
 =?utf-8?B?RTJBU25jZUZqZjh3clF6QzN6VTZLYTQ1NW5OZGRiS2FyWElRci96ZVV4OG5n?=
 =?utf-8?B?ZHZzOHpUOURZWmdTTVF1aHBtTlhpbUJJNmgxYXFaOWJxbnR0WUxucmhISlFm?=
 =?utf-8?B?b2hVays4cTdYNno3NFFKbFNKVVkzNFJNdG9NeTZYVlFHNEFHZCtMOWREK1N4?=
 =?utf-8?B?aGFvQUlRVkFJZEwvelZaajIwRjFZQVQxSEVXQ3FqWUhwWXNVR1dnS1hwbGZu?=
 =?utf-8?B?NURVSi9wV29DbXIyRGJ5Y1B3d3V6YjRDbnJTVXBRYkxEak5xQnNQQmpmNi9N?=
 =?utf-8?B?aTI5bXNFMjBqeHFBMmtSQm9FVTErQVlsYWU3bDZ2dm8rOUtWc21SMXRFWVRD?=
 =?utf-8?B?MkFIMTNlVVp6TlZxYkEweGtjMHVpb0VPY09jclZseTh5UmltZlE4aWR3Tkxi?=
 =?utf-8?B?WHdHNWEySmxRY2RtbjRZaWVYdDI4WWlVbGR6QjF4bG9nR3F2elZvSDBTTVl1?=
 =?utf-8?B?VGkzcmZTZ212ZUh1YkVIZWtFVkk1NU1lOEN4NU1XNEFnSHhBRjl0bXVJUXhz?=
 =?utf-8?B?ZkFJMWVoNWtub0grZDBTKzlrYzJkWTV1bHhlSkh5dlZkYXFycFAwQWM3b1Fk?=
 =?utf-8?B?eHByMmJJbS84NUxCNjdjTk5WaXQzdXFRYUgycnAyME9tNnJCZWlnVlBlVU1T?=
 =?utf-8?B?K3c3UGVFeDNHVGk4RkFXZXpaODRtVTlUMHpocjA3Q1U0S0F1Zm05SS9BYlli?=
 =?utf-8?B?dzI0OHpseUgwMHFFbEFGWVozaVdFcCtQTnlDQ2J4VjdVL1BKOE5MMk52R3FD?=
 =?utf-8?B?bXhHd0M0U01NRU03d0hvd244MEMzSzZrN2hhSjdpL2hTanRCNmROOHN5VHFT?=
 =?utf-8?B?QWlhZ3Q5dEtaKzNMcVFJQWlsdVE2NGhKNFJTZ0dCOFRuMXptMmFwc09NZk0z?=
 =?utf-8?B?cTlyU2U2SXpEODNucm1GNXhGVFViSlVMQlFvVXNORCtvcnorN0xNNU41S2ds?=
 =?utf-8?B?WnRpREEwdUZ3akZaYjcvcWNqeWtuNGJCSHJISnhmK2N2YXJ1eFdrK2E2TVAz?=
 =?utf-8?B?VGdnUUlDNkJQd1NlYVFkMXdIS0hEdStpOEg2b0NEbkplNFhGSW1veGwxM1Z5?=
 =?utf-8?B?K3liQkM2L2gxTm9XZ1A3QWFQWkR2b29sQStZaUxiYURLelJyaDhJNlkrQUdK?=
 =?utf-8?B?VVA4cGZmanNjbkNWcUVSaVVidUxWWFZ0YS9XSlJsTmIxd0xscHljYUZyYmh4?=
 =?utf-8?B?R2tEd0FqRlJTOUh2Z05ocHphN3dsQUtIbGprMDdZZXpxOTdNMFNTSEF3N3lL?=
 =?utf-8?B?ZkxVSzg5aytVODNSN3NPSE5uWnpvdHVoeXZuWFVxa0gzK2VYQmNCaks3U2hL?=
 =?utf-8?B?Zm5zVkZ5aVpRNllSOVR0bWsrV0VtVTZLVkpjZWtVbE1BNExXVm5hbnVxbHBJ?=
 =?utf-8?B?R1p5RHFEZFZxa1pjZmVmZWNRdlgyU1FKWEpZN3AvSnpTbVRoRzFDYlNRMHk4?=
 =?utf-8?Q?D+Led6dE+EexV82qGd229po8c?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 015692f9-7be5-4b24-fcfe-08db7e30d1cd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 14:53:54.8028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4JU+gx9FvJnasaIKTVUwprAxmxPoPv5a/6qBPx8sfs5hRx4HG/kd1hRRcpIRAr/yLmunMO7eh+/4hZVrIvahA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5848
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the delay on getting this out, it's been a crazy couple of weeks 
since KVM Forum. Here's my summary of the discussion had at the KVM Forum 
Trusted I/O BoF.

Some initial discussion of why Trusted I/O is really needed:

   - Secure end-to-end path between the CVM and the device
   - Performance advantage to avoid bounce buffering through shared memory
   - Attestation of device

The discussion turned to the device model and was more guest focused:

   - Where should the support to transition the TDI live?
     - PCI subsystem?
     - Device driver?
     - Other (such as in an SVSM)?

   - TDI readiness
     - Use an SVSM to take TDI to run state and hand to the OS
     - Firmware or kernel takes device to run state
     - Hot-plug like
       - Leave unlocked until guest requests to make device secure

   - Attestation
     - Generic or device specific?
       - Is it a device specific policy?
       - How to account for firmware revisions
       - Should we just care about the measurement?

     - Don't do any attestation
       - Use SYSFS to present an interface to "activate" secure device
       - Until activation, OS enforces DMA to shared memory
       - Remote attestation can be performed to decide activation

   - DMA security
     - Can MMIO be locked but still not make DMA secure to allow the device
       to be used similar to today
       - Allow DMA, but only allow to shared memory (software enforced)
       - Start in "OS non-secure" and move to "OS secure"
         - vIOMMU prevents access to the whole address space
         - Device driver work to transition DMA buffers
         - Can this state be detected?
           - What if OVMF has transitioned the device to secure
       - Firmware, e.g. OVMF, would need to do the same

       - The device should always be available for use
         - Device does not need to be attested to be used
         - Attestation could be done later to then move the device to
           "OS secure"

It was hard to hear at times during the discussion. Thanks to Christophe 
de Dinechin for recording the session and getting a copy of it to me.

Hopefully I didn't miss too much.

Thanks,
Tom
