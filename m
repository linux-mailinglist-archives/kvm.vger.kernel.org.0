Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70DD5F55F4
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 15:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJEN5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 09:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJEN5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 09:57:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7646567C;
        Wed,  5 Oct 2022 06:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkumViN9JiSlODspm8nYJFjdymPTTYJmSuKTA+tln/vecaYVPL3GJ+lrGv/riTuzHIneXUgbNp6KjLQShOMpxt2Q2QAdAM2qEPORHWF7aNDWx4L9cgHHLY7ylu3FjsVeEZB3o3drWbdMimTKVb0Q/7nNS2vphOrkHYVm+jPadnSkpxsErY8OlbXKTeUWPpcVxGVIki3aztP3ZfZn1RnVGGo2JGBm2/21c8Yt+SQrX9jCuyAM6Y2FPK+wbNy6RxdHigvHiM8J6Q+fKrsofxZkv1jbYL2lHFEWQIHdLSC0347kcfe996COwQhpn/Q0Nr+Hsswur5EzmMUf8K4PzplUjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk8vJsGPQpGvjhude0+apF7bM3grXm+7pZVMxAzhiqo=;
 b=aZfUBBTZQt54c1d8HIwVRVIm7k46+t5cenP3UqYwc0rOCf+5gb041NWgCltFtPbgza+qFwFf/G38PRWEeG3H3q4F/+1sRGRi4fpOB6t0ikSZmnToEhK9BhsUlHXjsapGQBVUGBqQST5/souWO5yDrhPILS7SrLcxZiP7D6rBNRcRnjv/d3QSPm3Lmz/FP6kncxFyP/yW1kmWRVnKTuaJ47hgzwr0Y0x+UrumP66c+fn+cwhaEyW+yA/HoOY4McYi5V92RTIP/uYUnlM+IX+56hB4EXKfPHBKYQg6ABD7qOZKbmu7DWXBO0Dc6JnRe4wZaQlLh9Y1lhqBnscsD+1j/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk8vJsGPQpGvjhude0+apF7bM3grXm+7pZVMxAzhiqo=;
 b=Krda83tUrHZ2jNy0XKYjt2Ok1qHIyinNJyA2m+ndIHPAbkNZePSQTuqs72q8QnyJZn+lkH0XOiMGiIadqpB67MC3Avdtsu65w2ACN0E9ezuRZ0N2M4gr4MWUUQDl0fzVy7nFMhizJJ+cCew/QcxJewc8tgxVgKVp0fnq0UvEMnCcbP0wpSJuJOc+AOlbdCao587tsC0lztrkgtXMWzs+RIOssSiFI6EfC/jGjt152U7ze6dgeDr6WPrcXM/90McfsSwvO4qzIB5oe/hFMhNK4VLsyYOlQ+aMSEbkmREXwK1exInGEWQakqRvO8o2/wauB6MQvuDTQUK7rN74qit2Bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7106.namprd12.prod.outlook.com (2603:10b6:806:2a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Wed, 5 Oct
 2022 13:57:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 13:57:29 +0000
Date:   Wed, 5 Oct 2022 10:57:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Message-ID: <Yz2NSDa3E6LpW1c5@nvidia.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
 <0a0d7937-316a-a0e2-9d7d-df8f3f8a38e3@linux.ibm.com>
 <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
 <8982bc22-9afa-dde4-9f4e-38948db58789@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8982bc22-9afa-dde4-9f4e-38948db58789@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0136.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7106:EE_
X-MS-Office365-Filtering-Correlation-Id: a28648f9-d2a2-42c8-4cde-08daa6d98ab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYRzSYe0azjaB9Y93Kr9bwcYdAFArvP7iaIufVv5XD5oCAvAvyX4NmbexOkOsI3cxHJL7uyCYhL9XdR0N7GEEyqibufbBGVk/cQLgW6uuoa5ow+1DjmeBOPo6o13gNm7cT3mhoCdkHn4khEJQ0+2PvIvA1yUfqVHdpO+LU3+5h7xUOLgx868J4Nz+rpOba05LRgsepAQRqRQDKHrFcxJ3m5gzdEdNntOv9SS68cjhQk4Q9JtYkOTGnCjAwwHvb/z65Wzp/onnL80R+Kk8DthTc2B4oxtJe/inPtiJPW3zd7SDgLEWd4dcdZC6zhJrn1aUebXKlcB0w+nJPD0u+yQ+WLbROiNPnP2EK4D5tfZeT8Fv+Dt7HkdgP232lztSbG5I7jNcH9F86YlkxiwtfAIC9Xrla9mx8MqFBzLDL0JfH05MkfyA7AJ2ErstL3BBgzMNlepXXboBU5Y6RFcCxd922SGbGGkmemsP8xqLzLbmYCZWs20dICVBkDmWD7s8PYMgmHtDpin5NenZFZkSvja3c4Je93pnoUO7hNo6laeKzPo7rVZHFEJv6kizVcXyIlmK3XoXi0uVmJxPYqxq30uI7wvk96V++2CO0eo0mL8Kxi9PeJVFUkuiXpHnrOaU1edVyG3fakVK+P2WEUuJaQ7FSsum5jKTeK1nhow4F+A8PnlqVXHl1hRhiME75hDd4MOBo30tjcxP4GEt3kXVxe2ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(7416002)(4744005)(2906002)(8936002)(41300700001)(66946007)(66556008)(66476007)(8676002)(86362001)(4326008)(54906003)(6916009)(316002)(6506007)(38100700002)(2616005)(6486002)(478600001)(186003)(5660300002)(6512007)(26005)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?min78wBHzIjUmOQ9OZ8+fqRVpeR2n8Q/3S+fp8U+YBvjEdsk0Oaen1ukTeRu?=
 =?us-ascii?Q?BGKQvUVTt94Nycnk5rdMve4q9cK/WnJ7DCd7K0RVFVKY1h1c6S3zGWD5nkHa?=
 =?us-ascii?Q?gMUqVADtB72QV23vtd74dAcgvIL7q08XIWkYZu/L33ta7Kcq+B6dkb6SqeeY?=
 =?us-ascii?Q?tc36TUkHN39A2nwFLlFRqYdC+dsuETxQszr7+a9M0ZmWbLkrUqqfuIFk2eYO?=
 =?us-ascii?Q?kNbYdH+CsNaiRW6wqKVDUc/beq3SgCFdZs3BJH/wOg2JhbXEu2DK/8PHNOKM?=
 =?us-ascii?Q?HbYAyRv2hdeyS1oaWZCX1ER2g3sL8vE0OSFQOEMwWvV9bRQ+Xoz4yQaYJirf?=
 =?us-ascii?Q?GwTeOZXzw1Beam/NGjryp/9lCkXEZxYYIhi9atConBmaGW9yux4PSqbPESAZ?=
 =?us-ascii?Q?VtkIxe1u36+Z3gSZrmtJ6NXJUR+533nnuOSWqDVvKFrdQeypAXeFE86aMPEZ?=
 =?us-ascii?Q?W5fxHH97X3uq/L/5HD8TYDguxgnGAosbaIlcb8EOT7SAB7louTF8nG1HMtyx?=
 =?us-ascii?Q?H88NmNTQfBbIayPhEDWKPZs6So0gZv/xWhSGfMfkaW1NTael8BkiGUW4WnL5?=
 =?us-ascii?Q?Gf60gWHlCXLgzjIb+HnJrNWYThnaEI0zsDjoWqUc2p7uYw1ToUDj/iDRSey0?=
 =?us-ascii?Q?tWkYiyRZ77R+Xa0lWi+slkS+f5soX0wKctkUZyGKGnk8/hclwkTdj4du0bZu?=
 =?us-ascii?Q?iN8hOw+kM4WNCrhkW6yK6/OjlWfnN8oGJRSsFUvAqQBbop3x+nM3GyMHpoga?=
 =?us-ascii?Q?40xbA1wFlOy7WHsOxWrdJClCCmPpgyRNoZkYDrHpFzUoE6O2I/J4YQFfdtWH?=
 =?us-ascii?Q?CYQLsaYG+sgrl/2PeYZdm8dzuL3EFWGn7UriouVhUE08Z+NAqjprayiKs+ID?=
 =?us-ascii?Q?QzbpBmeyF1W734hdp5nRip7i4u7fAhymQ/7i8E87mTHIoH61hKFaP2IgNtkT?=
 =?us-ascii?Q?PPxClSIMpl/EuyuwGr/RXd9L/fdJgtKXNoxGXgkF/QXzCXQFfh+M3ITPq//z?=
 =?us-ascii?Q?DlnEwioS1xv+HJ8sQr30FhAfnt4nEpfO6zLTUYod0szoTvqxLTCP0+uMzUFP?=
 =?us-ascii?Q?KPYxrSpj4Fq/DLp/0KzSQjiYjIeE6uUi6yYd7AThiMn6QP6xna0mjO66dunO?=
 =?us-ascii?Q?T+Af8B7oribjZfrDkvCAplG649/quNDjnF7g8M1FY7vMuojzvTKvf/1wtfVA?=
 =?us-ascii?Q?PBTNCUH2FStoMyhN1KV1/T+WzOnhdeDCs/b+AjERtPY84iKz/PfIIekg602r?=
 =?us-ascii?Q?cPgJSAG3+NoJx1uDR+fXVhnvGkywaFCa8S0x4M+2pJgvKWBqhZc2PWatbcQN?=
 =?us-ascii?Q?tcWV9DNRmJEqG91ydMeuk2ioBCHCrcUMNOlWhhnwxhV5xuxSa1+wmC2vEdr9?=
 =?us-ascii?Q?THCxhyEHmVhM64hs/GpvBfE2qmvB/cCW8ymrYScg5tZ9paSQxi0MSTXWQAz1?=
 =?us-ascii?Q?YTjtRYQ0N9U1PQHWgfumARiAfT4GnyS2SfvqP3EgZqaqyaYP4gcrALCt8zoV?=
 =?us-ascii?Q?qBvKwAz26jYdFDNapvYHOcVU8IiFhOYxnpJMN+A1NcVlel0B3xv23AiEPh33?=
 =?us-ascii?Q?BIdlfmKZJoSyHgMo6BU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28648f9-d2a2-42c8-4cde-08daa6d98ab1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 13:57:29.2741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4swNtt9DuSL3m06N2225CSp8XR17/6N+SnAW9BWYUimJg5d9Il2FXMn2900FOf4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7106
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 05, 2022 at 09:46:45AM -0400, Matthew Rosato wrote:

 
> (again, with the follow-up applied) Besides the panic above I just
> noticed there is also this warning that immediately precedes and is
> perhaps more useful.  Re: what triggers the WARN, both group->owner
> and group->owner_cnt are already 0

And this is after the 2nd try that fixes the locking?

This shows that vfio_group_detach_container() is called twice (which
was my guess), hoever this looks to be impossible as both calls are
protected by 'if (group->container)' and the function NULL's
group->container and it is all under the proper lock.

My guess was that missing locking caused the two cases to race and
trigger WARN, but the locking should fix that.

So I'm at a loss, can you investigate a bit?

Jason
