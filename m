Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CB43C718F
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhGMN5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 09:57:40 -0400
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:2113
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236827AbhGMN5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 09:57:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mc3i8pxlSGOe9ilnKlA/oY+rtl9A2xds5F9AmWMQP0mfzJekAGDqpmnHbpJRmUqRvFalpX9WHOqwfRQ9b8bpGtIq/gTfmIxT695YwVmazFhCTzQkPDnq2nyEiAK5ssV8LY+DaDeQnvtIz0Y99SwehGxRpu1xJaExywz80qfihmmnkGCHuH7kBhRhUKA7jPMet9T2lprFt5eK0k5QIkJKwwlNwTSAIVOmhUYQ408unGYQITIflT5Yj8TgamJi47uJpg1GlXK/LiYzqt7MAa3UZ4bfGTsjN7W4nm1dO3Bvoe4RbWhl4QhetBDDNoN6xIpAo8kaRpq6JR13m487Hr/Nsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAwcNuhkeXqrst0zvbLeSiA90hOvfGovGxktPlaA1MQ=;
 b=naQBXzX7UEj5N4St8emSZHxJVkt6/sgPNTuq7YFkHyprFUIQ3sx2MZi+u4e7aGFz/nSW2cNiSgNgG1UcRcViFnQ8p+V3uQFsWPsqcdL9Y0fICwrXx1UOCA3ikGU9pgvY6biP1fDL0crBJgNuD0DbDwW/mNqtwW26jyxvl3jXELx/lrdH1ITz1BfG5sPIiU1iJWpwA89jYtn+wwV+ipLayCJb7o8GSLHc8+7cU9VrCdf/41GxODc+lVBP6/KUv2uKH4WtKa9OcTIGlRxEdcsTOsi+lFDWio78r73uUyMHwfYQmTMnLaPBqymkX9Rl/khFFwAcJAOdmWRrfDlFGjnI/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAwcNuhkeXqrst0zvbLeSiA90hOvfGovGxktPlaA1MQ=;
 b=Db3gqDeXpIlKiThQ5DHr1rUcZy7h5t0oCWHUr1Rr+89nMOfdbprJFH9MnnPBHRRcuuN9pUiJ12kG/rdnlKWG4OMHj4fpWPMGCkn/xQpYgcJIrZWd5QSR0QH9DROFuXTuzf39CF39heNFz77FoTq3qIU+QKjfxRVTzj6Cvl0KxXU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2639.namprd12.prod.outlook.com (2603:10b6:805:75::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 13:54:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 13:54:46 +0000
Cc:     brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com> <YOxVIjuQnQnO9ytT@redhat.com>
 <cd63ed13-ba05-84de-ecba-6e497cf7874d@amd.com> <YOxswVowx3ksqMm3@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <34b975c7-6d14-733a-79a5-2eb1efff7538@amd.com>
Date:   Tue, 13 Jul 2021 08:54:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YOxswVowx3ksqMm3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0002.namprd08.prod.outlook.com
 (2603:10b6:803:29::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0801CA0002.namprd08.prod.outlook.com (2603:10b6:803:29::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 13:54:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 721d5e4f-4a33-475e-4634-08d94605c624
X-MS-TrafficTypeDiagnostic: SN6PR12MB2639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2639C6179A266ADA3B82E7A2E5149@SN6PR12MB2639.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QlwSxRrc6VYKz0AGqT61+PjNHwcMTYmZtmVL/DjPnOKCaBd4o8abM1vi+g1h/8xJCyqz529AN5MjobCJFhO7HaPYMfXwWhDIs9xbIGELMFRljdXq0Lk5iyMCiusVPuk//4CMRUuFEB7+tA6iZTm1k0RwJqrDyeV40WIHDqxoq+2UHnJbTiYZIjmaJ3d1ffUkuIV6hMPbCa3pAVTA1bZ994Gy55BMVZzX8GvpgGbyqskvU8CbjzgcMyT9hH+gehsXUxfZtYTkHoMTetsj+0V3Ui7MF82hD6YdAqAksVaM9gLtxtcoPXCP0yiPGw64UwQZnxwCdAqJPVnUM9BT5a/vIxoMYDrGfmGyz3GywCWCl27oV7AywxTfvJCfeCj6c4AMel0r/CrEjhxhBKD/QyHdXNtka0e7QoWbAxjHjeXI9XuxoloVeH2KNjKKxHQ6tCFSNcKbTMdmqAXcaQ6dx4yTkyNBnJWkVpkOBrkAivo+fBQeYQc8Yi8kLcFMBohExkdWVDXwF3YCi4dt2BTzH9jIV0p9PlSj/3hgKf8V/iiCTafQp2KlGF3euND8BeNbI7GLLJH6A/+GdKMR9ioT88q1puo3qHgGkRByhWEHD+SSa6hGoohDeeBoXkmcuQGKDWTvYiABf1t/wM8sPnOvdhu/yex8JjoVy7fyaBmFNB+o6dUP2B5ToZ6g5d0fx6wBF4OOz0/eFa8N+djNtJYixQd5hKsOqBBLOh8z9tHCV9wpld+J9xo4ChbeoqWSYDywZW6vKs7RlWxlVL7rbFxI76w7hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(44832011)(36756003)(2616005)(4326008)(956004)(16576012)(478600001)(2906002)(38100700002)(38350700002)(83380400001)(54906003)(8936002)(7416002)(8676002)(52116002)(45080400002)(5660300002)(26005)(966005)(31686004)(86362001)(66476007)(186003)(31696002)(66946007)(66556008)(6916009)(316002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmZ3QnRBYVlRcVpMTFlPbFlySkh6cmhUdWlWOHAwcFNFTCtVc3RvKzVuVTMw?=
 =?utf-8?B?b1lHTTlYMkN0bWtpWnpFNEkyZUYyY09na0lNZkZoT3dDcXUvZEpXejUvcnBo?=
 =?utf-8?B?ZWx3YWxrTkFHRUdtaTUzbjZyN1dSTG81aUp4UE53Z3MxNUhuSW5TemtlR1Zv?=
 =?utf-8?B?dVFnaWlYOTgzenVKb0MvVFJUeU1CbndROVJBT0RuTENGcWFqeG5XRUF3YXNB?=
 =?utf-8?B?L0Qrd2FYWWJiME9PdFplaGN1NU01THJwbnZoMlJwZTNpd3FaRkh3VEpVV3lr?=
 =?utf-8?B?VzJDcmNQN1VYSkoySHljanJrQjBPM2FoV2JIOWw0N0d2bnZ6Unk4M3JOMXBL?=
 =?utf-8?B?RkMzcFBLbHExVkdPa3IzR0hJcUh4S1hYdUpDbTJXbVBET2pTODMxbUo5Q0Nh?=
 =?utf-8?B?SU82ZnhVczZOQ2pqVGZxZFBJUXQ4NDdLQWcxUUZsZ2dIUFE2T0ZVZThicnIr?=
 =?utf-8?B?QkF3RkY5UjhSdzlmbCtJMDB5UFo2RWY2Ujl5Vi96Y0ZjaWNwRDRKbUZyV0FS?=
 =?utf-8?B?VjFqdUp1SytOQXF6N3B0Z0RFd2ZJdXZVYmNOWW9BYlh4VngxRkk3OXVVZ2M2?=
 =?utf-8?B?ZzJ5V0lwRWVzK2p3dUZRdU02NkxQRFoxMytNNlFxcUxUenlhL1dsN0NXY1Nk?=
 =?utf-8?B?cnRva0lwYnNqOFQwaHFudENmNzhCU1pLUEpUMkZ1UGlFaVZTdHJKUHl6VjJQ?=
 =?utf-8?B?MElVaklGZnlZQW42OUxyMUJkZlhkL0U4N1FzaGhRWm9YOUUyRmwwUXBwNTEw?=
 =?utf-8?B?VGlCbEh5L1AxcGN3Rm9uODNWUXZyb1N1aHlpMnpFd0dNMytxM2V5WkhVcE9t?=
 =?utf-8?B?VXNxVmc2M2tsQnNiVVpmUis5RW1tbG5vckcyNFJsV1RrcWtiMCtDSUMwYlM2?=
 =?utf-8?B?NEpBVnBZT2NYOGhmYlNHUEoyZmgyK1pPemdjdGNiUGdQcU9QYjIxb2lrV3Ft?=
 =?utf-8?B?enpEVkNjTm5vdG1ZV1hJSDZjaHFYS1l6L1RhVDN5YWF6MjBqWHBrekNXc0Zo?=
 =?utf-8?B?RlFQVUhIWXZVMW50K2xjRm92TkZkMmNET2crRkt4VmR1RHFEdEJOaFlkZGVW?=
 =?utf-8?B?SFllU1lJMUc3OWxqM05DSERpQm5pdGxVd3l6Z3BOR1VnckRMMllvWWhINkNC?=
 =?utf-8?B?SXBiODlaNXlEeEVldVF5aVNYbmpFeFI5MXZFOU1LWkFLNFkxS1d3VUdQbTVO?=
 =?utf-8?B?aC9XRlJXbVU3NGFFVDVtL2JMdUV4ZDJUMUR4MnBvalRSSTJGc2NxMDBQRVdO?=
 =?utf-8?B?dStWK3Y0V3VXQXNoTUExRlBiNWRSVW8vUjJDM2JRbUoxRU1wb09vRGtsTGNl?=
 =?utf-8?B?eWt3T1lRSTltVUZWZjhyeU14Wk9XMkhQcXJBYTFScVBkb2RwOCtBeFU1YktS?=
 =?utf-8?B?dlVPRkc5TkN6RGFSVXVOTnVpb25xaFV1b1AyOHd1Y0EyemM0RWlvL0s5Sm9a?=
 =?utf-8?B?aTZSR0U1cjEzUUI5TGpRNDJXTHlmMG4yK3BDS3A4azVKNHF3ZGd4UFN2MVdV?=
 =?utf-8?B?bWJYY0FGSkVEbWhDRnkzMVR0YjB2aUh1VHNYUk00YWFHcFdLZlBhLy9HU1V1?=
 =?utf-8?B?M1Y4cGpndFdmcFlrMStESllBMWtjR0c2VXdDaWZmb0ZUTU1FdWNyMG9QRGZw?=
 =?utf-8?B?UjZXYUVweER2ZVEyRk9wWk5xUkRlMTZOdks1QjMyTU5UQUxOSWpGaUNxblNZ?=
 =?utf-8?B?bmppUjUvQXZDWmp1MVZCdG9wdXE2MjgyTTUxT2wwU2YzQjRnZmZ3WC9ieVRy?=
 =?utf-8?Q?IUofZXUcvYIkQ97Zw9IGROx+hwaO6nll801VG79?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 721d5e4f-4a33-475e-4634-08d94605c624
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 13:54:46.6140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnN20Ke8xUpQuuDEgQ2xB0vNBbTraDdi3DH0edBYA810bHnKJwyFxvxCV6PxT5eJkZ9Dh0ImyryvgkjlgHT9vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2639
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/21 11:24 AM, Daniel P. Berrangé wrote:>>
>> policy: 8 bytes
>> flags: 8 bytes
>> id_block: 96 bytes
>> id_auth: 4096 bytes
>> host_data: 32 bytes
>> gosvw: 16 bytes
> 
> Only the id_auth parameter is really considered large here.
> 
> When you say "up to a page size", that implies that the size is
> actually variable.  Is that correct, and if so, what is a real
> world common size going to be ? Is the common size much smaller
> than this upper limit ? If so I'd just ignore the issue entirely.

Looking at the recent spec, it appears that id_auth is fixed to 4K.

> 
> If not, then, 4k on the command line is certainly ugly, but isn't
> technically impossible. It would be similarly ugly to have this
> value stuffed into a libvirt XML configuration for that matter.
> 
> One option is to supply only that one parameter via an external
> file, with the file being an opaque blob whose context is the
> parameter value thus avoiding inventing a custom file format
> parser.
> 
> When "id_auth" is described as "authentication data", are there
> any secrecy requirements around this ?
> 

Yes this sounds much better, we have been using the similar approach for 
the SEV in which we pass the PDH and session blob through the file.


> QEMU does have the '-object secret' framework for passing blobs
> of sensitive data to QEMU and can allow passing via a file:
> 
>    https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fqemu-project.gitlab.io%2Fqemu%2Fsystem%2Fsecrets.html&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C891fdc1ab0d8483aecb808d945519054%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637617038899405482%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=8AHUC3DeyauxT4Pd2ZkUJkDyu9XHtexybM0BgdRlego%3D&amp;reserved=0
> 
> Even if this doesn't actually need to be kept private, we
> could decide to simply (ab)use the 'secret' object anyway
> as a way to let it be passed in out of band via a file.
> 

The content of the field does not need to be protected. It's a public 
information, so I am not sure the secrets object fits here.

thanks
