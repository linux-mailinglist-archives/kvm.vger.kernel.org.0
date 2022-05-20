Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57E652E486
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 07:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345608AbiETFvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 01:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238464AbiETFvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 01:51:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F285AEC6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 22:51:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJNVOlMLsl2asi+XjN3S2YC+EW9KEZexIcff5SJT43taOAGcp9Lb9UpiP/uWXvJhH4G927cSx3dl2pjA/lf5Fjy0AhNVw1sl4gfU+KlvP+MLn9Z6Cee+MWcGGIntTXmgazWKNlOuzrn11oOzCl+WLlXZHIVkxQW4dC0JHXE1q7LpJCp5zEBcK3KopsUaV2nxPBJLUvuHrc7jwGOSHpoS/+uE10obaDM6gsKr99SozGKt4KzvXKBmBX2ToA6X8rWvzq0NrukTyIG1kUmam9cioG0b1Vpgt186Nfhm2DTzwvNt4Wa/WTp4jM7g4taDMzWMIXduZ59irHsEukEs46ZRAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amPa8QfeUQnHyZGa4kggc2zB2Xiyvx6ww3hM40kJu8U=;
 b=afopdHFVYHkK3MO/Uyn5k+zpK/b2+M1SB8SiHiQVeK+4JxdY/Jv5jkhX0ik8Z3Wnle41adpM94e/jmaZ0jITwHMMLtDT3HknzO4PkcmLURdveqxxC3preNRRlovGyjc2JKL37FcKL1GYJn0wktXKbqdEgSrNBl8DzeX7oFcfSOw4q9yJWonIogphzNJ3caAcOmzgjwlMO82txnuc0l1ex2BJjZpg1Xex1TDRhtZAFzD+fBwLRaMh2sxvEIZY5ot/q1ZeLTjdH+O6dpwSgIhQUYo0DeV6VmsRvfHaf5mJ+ATX4UuDEVEWfWsIDGgTGcUjx4yXjnLYjE7+hdJ1PEwIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amPa8QfeUQnHyZGa4kggc2zB2Xiyvx6ww3hM40kJu8U=;
 b=TPoZ6SklOg6pbIa1zrKl6L2bExky8P+8VmJJunx/ss/5NMt/K0F0Zl/WXx4SV5aL0VA16/cwssdO1wZUd43yGZDPxfGfphE7rvUfEaG62fKk/zVfasmWKbM+WGJv+lOpsGUTYe6uhYjBaps5v35Xysd6XyZ8vWDbbijJoXFT5Y0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MWHPR12MB1693.namprd12.prod.outlook.com (2603:10b6:301:10::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.16; Fri, 20 May 2022 05:51:32 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::8c27:b470:84f9:82b8]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::8c27:b470:84f9:82b8%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 05:51:32 +0000
Message-ID: <38bf8c88-d8a7-47ec-d940-44b0b0a62129@amd.com>
Date:   Fri, 20 May 2022 12:51:21 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [RFC] KVM / QEMU: Introduce Interface for Querying APICv Info
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
Cc:     qemu-devel@nongnu.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        mst@redhat.com, "Grimm, Jon" <jon.grimm@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Wei Huang <wei.huang2@amd.com>
References: <7e0d22fa-b9b0-ad1a-3a37-a450ec5d73e8@amd.com>
 <20220520052644.GA15937@gao-cwp>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220520052644.GA15937@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::23)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5241b83e-82e4-4e89-add1-08da3a24ca72
X-MS-TrafficTypeDiagnostic: MWHPR12MB1693:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB169392F563B87D2E127DE3FEF3D39@MWHPR12MB1693.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ieQkVKat3LUB7QNyWaMsmYHXAKA7o4IufZjtgsEuF2bs2S9qyTqLD6Czx2Jk7OPETp6vT0uOagvze30mDzE9VeVJy5lLGMaIfAdXXV/kaFdmmAk1IxsSxDL+16GTvLu56gtx+1d0b1xFXCgA5ZZ2jEGueLYA2ZONkiG6rCR/nOdyrETRYwgASdbAWUbCaYjNcjdSYX+EE+jTwXSWWPh5pk/vErr4Iw6ECbOcfySdVSDrkuWe99pHDC68G9XygctRyWtAY6nEf+6d+CnZW/y8CRNJCtwXzoyhUaNdXrYUGE61WFP6xJdFTXZ53C0y5NJs73Rh17mxC6/itWp3akVp/hsV4Mm9I9NDUP2Wze4gVnruyB4YIqSn0WL81J7mmVTWcJRY3HefOi4y/aSAAvPtVacBCyzcUe9XVLnfehdyIGUJrvtLhFcuUkB5ycw3LvDA3OHUDlMW0OmYgveXiL5rAnh6MDCbHQ1iwdlmJ0cpGDrqY6E1sC8GbPZjuS9FFfrSMuxHNvZt6mBQfUtG0R4cdHNUaz3BJoIX8a1mM/dzf0ouSrGFFwgf1pnUtgQjVsZWtJ0NOPOm1oqr8tU5OaAv8BhisjRZtgfR1UGPj2LOkRZ5kzEpxWNyqval2Y0I8vcqZiz6j4HbQWxK3gxuxBadwB6Kei254wlKnvGf9IMX3ZY0gYhZHQUEiveg+PPYcMGez566+Fy0B0+wuHrsYoNxqL4QqgCJiwNyG+e7/CjZvucs+N2h+houH6hbu64OBJq7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(36756003)(31686004)(44832011)(6486002)(6506007)(6512007)(53546011)(26005)(5660300002)(2906002)(508600001)(31696002)(6666004)(2616005)(86362001)(8676002)(66476007)(66556008)(6916009)(54906003)(66946007)(4326008)(316002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnJUTFVHV3JES0orQ0MvUXBWYlZjSmhZT1Budys3V1VDc0QvNnlveitQNWJs?=
 =?utf-8?B?STdndXllUjNOcTZ0dDRtWmM0K25JYnBPVDFXZDlHbUhWMGdET0QrakpEZmJi?=
 =?utf-8?B?Tk5KSnZkR0poUCtBcTkzSFVBdHNzYlJiYWJkcExPcmpEYmQrUFVOZ3Rmbzlp?=
 =?utf-8?B?UmtVQVdFRm9WZ0lSbEZlMDRFSlZ6aThJbnBWZXlsQ0l3d0N5Vm13Vmp1bUha?=
 =?utf-8?B?eTJvQTc1bFppdTY1YkR4WGtFUEh3dC9URHhrcWtnaTBGU0xSSEw1QWszblJr?=
 =?utf-8?B?cHc2NnExNmVVNDlNdnBzMjJqVGtPdmVZdjhYd2ExVUJiNGUxREVOd29rOUQw?=
 =?utf-8?B?MVNTYlExQjlidVAzcEpDQzNZTmMrT2pSVWh6RmRXcGtUem5zOFI5SmdGbWhq?=
 =?utf-8?B?T2c0VVlFMWNpTU42dWl2S0J4TSt6b0JmQkJSMkFQWm5DN3U2bWhINlNwT1NH?=
 =?utf-8?B?czl6VnV2RU5XQnN6R1RYdWdtZmpPSkxYMVQ3T296UVhSMDNBM0RGVkJ3Y3NJ?=
 =?utf-8?B?L1M2YWFjb0pUNFF3MURGZCtlQ041ZkRaWWhvb2d1VkRLYWdBeFF6OFFJZ0gv?=
 =?utf-8?B?Rlk4WWR4cE5Eb0gvZHNFclpBcTVHWFRjRGlpSUppZlN4NDFlMkV3S3hjWWtW?=
 =?utf-8?B?cFRlZCtnOUtQVGVKWm84TkI2S2pxWDhWWjZLL0ZGamxDTHdMVmhjbWkyUDcz?=
 =?utf-8?B?QjlqTXJ5TG9sNk4xQ3RpUVc4Y2YzckFhbzlIOE9FZUhZZllVK1ZSdEdKSWNJ?=
 =?utf-8?B?ZWM4UXkwNDNpRVU2T3h5cHZRUSs5VHFGWERGZjFCT0ZzY0JTVytrMWIwU29x?=
 =?utf-8?B?RHpVSDEwbzdPQ3d4WTJxZVlaczRUYmxuditHTHlha0orbjNFdXFXN3BXQkpS?=
 =?utf-8?B?YnowQWtjN2hQQXViRjVRbVZGR1RZaTdFaHJwaWRFenFJY1c5emRXODRKSHQw?=
 =?utf-8?B?Umx0cE1FYnppQXN3Znl6U21US3Y3KzRLNUg0eDhISE1YR3FwMlNUVE9qcGdP?=
 =?utf-8?B?SS9DNXF3WUZ1cGswbjgrdkNEUjN0L2hiL25CTGtnbEx5N3kzS2pBay9OQXRZ?=
 =?utf-8?B?VTFvRml3eDRDR28xMmRkNHA5ZTlPUFJRblU0VjJIckV6eW15R0F0dWlMcDVM?=
 =?utf-8?B?Tmw3VWpmUEErQUxQR0tLT3BhQTVweWx2MEVQdXpkZmlVN2o3aVZrYkVwQ0gz?=
 =?utf-8?B?alNLUC9iRkREY1FqekF3K3BZNkcwTG5HcDEya2hTTE5KNXNyOGNFcGpMRlI5?=
 =?utf-8?B?SGJNUnliSjNPMUg1QTY1ZTlLWUM2V3IydUMxc21tVERST3pZWW0veWU1Qk1a?=
 =?utf-8?B?YzB1eUlBU05Ra05LRlVHTGI3Z3BZNE9YR3hGNFhpcDc4T3JFQm1lWDNDU1Ix?=
 =?utf-8?B?RjNXSDEycTh4aHRGemluVXZBdlQvWU5aQVllVnpwcEpIdUxob09nRktLT3c1?=
 =?utf-8?B?MUZvZzg1ZjZHd2hsU1NXaHNxMVE3Q3hDRXFrN013aFFtQlVVSmkxbGRnRkZ3?=
 =?utf-8?B?RWFJSU5PNko2RHZlMVJSV2pSL3hNZnpOOXNwT0w4dGs5VW40YUFoNjIyM3FU?=
 =?utf-8?B?YmxsWHZNV2hRalRPVXlYRWRNanlOZjFqZzJPcHhDR0txcjRqR2hHeW15NndO?=
 =?utf-8?B?RGt5SzJsOWF6TVpsbFpGSXJCMkx4RUtLanFRTTZ2Vnh5M0dEbjl2bDhmU0hj?=
 =?utf-8?B?MGJBSjkzUVBydEprOW1lWWNYcUtzOGo5YWw5MEJBK1hYZm9TZFpqUnp1RWRs?=
 =?utf-8?B?bWNOd1NkbXdVM0dUZkFPRDllMVpOSDFTam8yZklUbFhTdmRGcGpMd0ZWS0Vo?=
 =?utf-8?B?eGV5QTRLRGFpajJLU2R6SGMrUllwTFU0SUR3NVplcW8xS24rRzM0bjk4TjBj?=
 =?utf-8?B?TEJ3MEErOUVXMUUxUng3VGt6dzVDWXJwdkh3MHU0bU03M0hnMzVtQnYvNmww?=
 =?utf-8?B?eFRvWTlQQ1B3c3ZMWi9zM2xPSEJKVTYzblc3eTFSVWRRTll0YXhYQmFTOTVz?=
 =?utf-8?B?M1BRUyt0ZVgySUIzSVZEdDZWRjNudEduMlUxVUF6amhsWCtDMGh2T1dnVFJZ?=
 =?utf-8?B?ZGlycW1WN3g3UVcvQjAyanh0aHczSkZvcGMzSXdkTzFJODgvYmQ0TVpHcDJQ?=
 =?utf-8?B?SlA4OXY1dkFTajlnR0dDMWVKYVRVOElza2NXc3hxRGpQZVJsYzAzSFpZSkpu?=
 =?utf-8?B?SDV6RCtVNVFQMGhNa3ZlSE9GWm9WQllSU2taT2JOUGZsak5VaThCWjJnajhW?=
 =?utf-8?B?aVhEWjF5TGNyR1Zmb2FDbVhtUEtFNXZqSkhBTGFYYUU4dzRzVWpRYmRFbXc0?=
 =?utf-8?B?NHJnWFBGNlhFL1FkendUQnJRalhDVnV4MXpDaDlMNGhhYjVoUUhKQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5241b83e-82e4-4e89-add1-08da3a24ca72
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 05:51:31.9855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvKneNYEkF7Rbw65m64r+GkrTtJYNV/wXEpaQICXp1L7v97E/rBoKVbrGayM2vQjxDLdgrk6mvN1r9tIay01yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1693
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/22 12:26 PM, Chao Gao wrote:
> On Fri, May 20, 2022 at 10:30:40AM +0700, Suthikulpanit, Suravee wrote:
>> Hi All,
>>
>> Currently, we don't have a good way to check whether APICV is active on a VM.
>> Normally, For AMD SVM AVIC, users either have to check for trace point, or using
>> "perf kvm stat live" to catch AVIC-related #VMEXIT.
>>
>> For KVM, I would like to propose introducing a new IOCTL interface (i.e. KVM_GET_APICV_INFO),
>> where user-space tools (e.g. QEMU monitor) can query run-time information of APICv for VM and vCPUs
>> such as APICv inhibit reason flags.
>>
>> For QEMU, we can leverage the "info lapic" command, and append the APICV information after
>> all LAPIC register information:
>>
>> For example:
>>
>> ----- Begin Snippet -----
>> (qemu) info lapic 0
>> dumping local APIC state for CPU 0
>>
>> LVT0     0x00010700 active-hi edge  masked                      ExtINT (vec 0)
>> LVT1     0x00000400 active-hi edge                              NMI
>> LVTPC    0x00010000 active-hi edge  masked                      Fixed  (vec 0)
>> LVTERR   0x000000fe active-hi edge                              Fixed  (vec 254)
>> LVTTHMR  0x00010000 active-hi edge  masked                      Fixed  (vec 0)
>> LVTT     0x000400ee active-hi edge                 tsc-deadline Fixed  (vec 238)
>> Timer    DCR=0x0 (divide by 2) initial_count = 0 current_count = 0
>> SPIV     0x000001ff APIC enabled, focus=off, spurious vec 255
>> ICR      0x000000fd physical edge de-assert no-shorthand
>> ICR2     0x00000005 cpu 5 (X2APIC ID)
>> ESR      0x00000000
>> ISR      (none)
>> IRR      (none)
>>
>> APR 0x00 TPR 0x00 DFR 0x0f LDR 0x00PPR 0x00
>>
>> APICV   vm inhibit: 0x10 <-- HERE
>> APICV vcpu inhibit: 0 <-- HERE
>>
>> ------ End Snippet ------
>>
>> Otherwise, we can have APICv-specific info command (e.g. info apicv).
> 
> I think this information can be added to kvm per-vm/vcpu debugfs. Then no
> qemu change is needed.

I used to suggest the KVM debugfs approach in the past, but someone has suggested that it might be better to have a 
proper interface and leverage QEMU monitor. The debugfs would be difficult to use if we have large number of VMs, where 
we need to locate qemu PID and search in the /sys/kernel/debug/kvm/xxxx. Although, it would be easy to write a shell 
script to read the information from these files.

With IOCTL interface, other user-space tools/libraries can also query this information.

We can also have both :)

Best Regards,
Suravee
