Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE217A9E26
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjIUT6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjIUT54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:57:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03E4A3467
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:51:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZ2A++mKBWyn8lY+hkh7Y8J64Drt102hNmnCtDgI6JjB4/GWHPEqBBu6xzwEhvAy/qcp0Wp401FfDyome1mYtZbqsAq6PrqBYlbPdvf93q2JlI4URdowMBvVeer1q5iQjvpYkuqRTpeVOUOFxcf5eMCXX9/kitY49OlCTIqDy5JbNmz31HUkUyU08BlU90t9pVdhzU8e5Akf+S3O/ot9jMEDs7AC7jzF6vdQ4QC0rBWQk3xR/0nRBuN1CthJX6kd5Q8ff1AJ+AyKhxbZbMcwvcnGGQwqdK5ECwla+oIR016fuMs1rEiDHLbXoK25L9grl5vvJlDzxWPgEgUx/JN1IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWo4ROFr9BHWrXGHER9K7kgiKfEc6BLooKJiCU4Q1ik=;
 b=XdGTHo9CM1kdr10AFyEq3lP2sh8J5t4sdaclgV3bWp33zfFvAykG6KcXwi9PKi7YkD1BquILcM69RwChH6aOu8bEBezm/fLpK9e29S6DxrrjwVDeUV2RtQ9aHkPuJj6SK2DgNHV0sQn7KmQx6Lc1ycZ/HnLXuMcRxpDiIRyNnKJgQnGTvZvTNq9pOejIKadaZJLFkCSQNWvhnmk4KB4k89D+bT7gaK9ycUjkUInqu5AfucvoqwSm9h/QdDMa2r8O00R5vWL+42unyCwp1/9LwLDyvhvoDkAEd+jp86NDnwAtnuhWVhjEQS+6a/UkpovDgLkz0/W4Jn55UeRfU1ty3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWo4ROFr9BHWrXGHER9K7kgiKfEc6BLooKJiCU4Q1ik=;
 b=l1uM9PvGMN/wFtOECdkVrfnJzICR3WLeUqv0oQ/9j5nRxzhRs6WPNb1eO0jJCilMU9icYewuhyO8yiQrlWiudrTd2qVTE0qpLSzLYHsefrm0eV1wirgEcOn2QFvaveBWL94Be7Rm98o/umvba5B6JHw7elhNWNAKRxT95WugVYMhlwevr/JA7oqP6G5AvOS7cn6VnCBcx3r/L5DzK+iqAl6JBMhtH+w/eB2FPAIOs+1CK2fSfVZm5tQ0GYLH47LgtLOaj8BynxOt5nel8UP9agKepxUucMRgSoL6QFfahlfBDj/pDwwNBxWPtwVNdDcWzKWxNSOt47muNmJ7PL8ZhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB8606.namprd12.prod.outlook.com (2603:10b6:510:1ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 19:51:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 19:51:16 +0000
Date:   Thu, 21 Sep 2023 16:51:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921195115.GY13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921151325-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921151325-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:208:160::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB8606:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e765574-d6d8-493e-0414-08dbbadc1e2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 22OHSzfUBLvnNlRjCrwHFCwdcr18kfUkBGCJ3/YCbFTeHXDmcwobBpDEuxEfq1MDoCmMD+8yO0ZQmL5HRB0oktLTVvZze2W6tG8sTdxusD5XXLegYwz6Eop0K3WmqGTAyXEcJUBEsnN+8SRrXbzQkFotETk+jgZ19OL2pKkbo+EjlfDpYlTcMNhTSa3A95QS51wxD7NOovJPUjPjtyHxYOR1TQkq7uirBx8rZ7/YYVjfTFu4pAcIeskBW+oy5tsttFJa5G54DYospdg+uxCI7vtW+w2eRbV7F++AtKCCBWmarIe45d4qZXfbPO4bRMBqEkGfSRrd9hh/4eUBOqqszOXCuSlIrrb1VAgG3T9n933x/qof7TMitxModo4760jBlJKX/GuiIEgebka9IOSJ1DEU7lDkIlD7i/mA4lfWXKSpglSX9OJB/p2aP2dBMWypxhkBo7egYPjLedl5ZjYlkGy9eK9pYrOseBRQOBpoTzg1+9+k5OMCIY9fkRv06rCK/cXIiUV8El0/C82inp8+YfHLinYv+HQI+imFBllZp79wT7f6EjqXGuoDssCgSiWI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(136003)(39860400002)(1800799009)(186009)(451199024)(4744005)(2906002)(5660300002)(6512007)(8936002)(8676002)(4326008)(33656002)(86362001)(6916009)(1076003)(316002)(26005)(38100700002)(66476007)(36756003)(41300700001)(2616005)(107886003)(6486002)(66556008)(478600001)(66946007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wo0Kz259+a97wiCuw9T/eCaaBwjYTiPpLgGSsGRj/bW0g5tTlLZe+hur1Kww?=
 =?us-ascii?Q?Lj6h5WmpgOpBMhwY+5+o+TGg3iItQvsKCHmNL8/MnfxLUXZY1DUFjd00/rwm?=
 =?us-ascii?Q?1iLlnRX5yYTR2nkn/x2fyYz3dnST2/c0w/sGKNyzP0m2Mt05vXi47efaCEYd?=
 =?us-ascii?Q?EGfylvH4ja2AuRnW8F5IBUB2aHi3eyZOEarls6mJoVS4yfzLJTNdFQ4Mihng?=
 =?us-ascii?Q?gk7BGAXmhitTvLplQ5Jnx62QFyJM2YvtsB9v62o7773iWn7FFfBL/mX2QbKn?=
 =?us-ascii?Q?fmNnsu9Mz9BWbC30vwlyp84P4CTIYXb6QvYgH3iGBM7MBOYE6pWeT4hemuzr?=
 =?us-ascii?Q?p6hULNqBqIH0fn3kT4iyV2ZRayLqBCptIL5W63dCs9zL9t0fBpUWoNloB72Z?=
 =?us-ascii?Q?Q0E1/QY6ruf2ZdD/6PXKC37py08JFlIPE7qa1Ke09iOPs6AIXbpFcs521sJG?=
 =?us-ascii?Q?aBXL9YAq0nYQ+jBYF0iyCxeqKOLYjmvMISxe0LML0aFfz776ZmLUI7kVW2nh?=
 =?us-ascii?Q?3CLh2JNl9mySsKPSYtWPSfrMSJ6KkV9JXi6P77fx13fz0QK0PvVJSGkx8T6i?=
 =?us-ascii?Q?72IQVZHUiPNvBSsRn/LvlcmsYera9zj18/goOSJesMM6PJBZORk3jMxAI3Uc?=
 =?us-ascii?Q?juGupRLwhfPwqRzxpoR6xACfAqjbdygQOPV+jWQzneBfDdHZEHpG9FQSrTxL?=
 =?us-ascii?Q?3zq0gQ907JsA6GA3hnn2oT7t5B4eCrP0Svg5QKx/zCLM0q9RGMeVWL+rleAG?=
 =?us-ascii?Q?l0vJQiFkdzKwdWp8vA7EQSzPZYcHHs8p8kFxqbFQps9X6BOaeK3D2/71wAVR?=
 =?us-ascii?Q?xfLWtqhWf+DivdqeVSalFmr/JqdoCQTeoCJOOvSN6Y4RHPJsqQS9cWvRXKHo?=
 =?us-ascii?Q?NSvclZ4QGzHf0WQKUZaLc4+SdhQh18jm8g1n8If29MaBFbA8DCB8Rpw4f92Z?=
 =?us-ascii?Q?eAul2DkQU33EV8ptC7XOtfirkuKzdcufeBc/EWQnSoLcFIey56JZTx+xAU3h?=
 =?us-ascii?Q?X/KlxdICcIjqa+WxzAVkNcDMwAnE93gjWy1z3iqWQ5yRGYdwpmHZoI7CmgSO?=
 =?us-ascii?Q?Dg3t/YFH5xJZGdURaqXbPrPVKJOFsxYLn9YenDt/zZ6ZL62ktYtoxa6VfU0W?=
 =?us-ascii?Q?oFNE9a+6DTDY81/dY20oJTBLM04Ytc0EJW6/CIZUq+CkbIVSWMkdnfiVF6CX?=
 =?us-ascii?Q?zXCIZ4tuS3WOhxhllw4GhAIOxdn1XqIG5nQSVYh1ojvcV/Mk1isSqaMiP0CN?=
 =?us-ascii?Q?96SJj5RHuAnFbPU0c7M98OJRATXWCYAXLuJpK05dh4EVY7/h6Hggixuf1vFk?=
 =?us-ascii?Q?hEL9LE3cWokzUQWyP9LYOvjq53sEIXiWkVnQOvQIxWWeLfHJJIWJjOH2s77k?=
 =?us-ascii?Q?HMrf+TSLFKt9Zg03T4KcRrRNkH7GUpX/U8FgX3L8YUaVpeo6OPimTiEiOqnt?=
 =?us-ascii?Q?meGPusXg3sac5hZKt63NXgGDoEML+v/Uq6MHp59OAAxsvQd8REsui7oRG59Q?=
 =?us-ascii?Q?dz/h5/MDY1Q+BrEV4Igm3koYxay7+Eh0DAEUKTIXOjUdnzm4nALKSxwY7AMP?=
 =?us-ascii?Q?yzlfMT7XMgausn/37qbNe78VuUe/PRwMiuT6OcQR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e765574-d6d8-493e-0414-08dbbadc1e2a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 19:51:16.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USx1LWzJtd22hdRQN6P3qU5Fka7GzhGCGPTdu8U7llplTgqZqaTMOsro9T+C0gRM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8606
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:17:25PM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > > What is the huge amount of work am I asking to do?
> > 
> > You are asking us to invest in the complexity of VDPA through out
> > (keep it working, keep it secure, invest time in deploying and
> > debugging in the field)
> 
> I'm asking you to do nothing of the kind - I am saying that this code
> will have to be duplicated in vdpa,

Why would that be needed?

> and so I am asking what exactly is missing to just keep it all
> there.

VFIO. Seriously, we don't want unnecessary mediation in this path at
all.

> note I didn't ask you to add iommufd to vdpa though that would be
> nice ;)

I did once send someone to look.. It didn't succeed :(

Jason
