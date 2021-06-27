Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEEB3B55CE
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 01:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhF0XWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Jun 2021 19:22:54 -0400
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:8481
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231491AbhF0XWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Jun 2021 19:22:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kutkPxWSb5ED8WyWJmVu83sEKlk+GY1WuKR2IIu2vLOWACshyy8zp0667NXrUEQY9ey7urixmULU7eVBnUF72E9FC/riIwZ2NuPFLAQhME/J1sOXhoEKRglbCnpW8toDElFpkwzXBrvBK6ToX14xg7TaWVbkggnV6O7RKR1CQ/r5XT3qunY6WDiDB+SvhgJIel7XjQ4/k/Buo1JlkF8OgOyRC+vL/KtEPvk7qNr5Qxe8WqfJ6/XgAfC61Hl2XUAf7LolcUllLDchENBKy1R8rYgt294ti7eX/Xu8xViVAVRSWhDbtNlkfkrP8VctIvQ27oXxQTibH6bj1nBEA0E8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay0H5dY+T9ONKPQBQyxok2csagqNAjUuxxqyHnwBQNk=;
 b=KmNKWqWCWjA4P2+COUo+s4jnypENooTBp1dk5smmSh+fGBi+SdRJ6NIym27+k6XABCJOft39GRTzzfl+5AodUgRhgq4gXz1tazNRFpKw0BCJ7hA/8fmBqEuGI58fs6rvq23hjSAORoTG4MMHIDQxhnM67fS8zHk0RFAn5bnv4t4o66v8GgsNCN6xWadRmt3oRvCF5G4CeKLk0My7mjr38E83F+oXVHuMe6lYHSFXuyxT88sgENVwkl92dsQOMXO2Emq+Ll4xIpozh2fx4pg++ZXq/8dtLjkeBJ4ecjI0ibE+PJ/i0Q0mb6ajHyfYnub9c0BU3B7r4RMPQICB+GsQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay0H5dY+T9ONKPQBQyxok2csagqNAjUuxxqyHnwBQNk=;
 b=tjfXhEIXt3b6IX3QeLumap16TcnMtjV02DxH2/PihqaP+P7ZNQhEyg+27Td3I8W4Eh47dhsgN9BO8LSWlYJhH80soFUaDTJ9JjBcu/DOJKoKCaSw99tnCUo3Cwzb/nZldK9FyGQcRyo2ZrFQqJcqkhjQ2tS5H8eoLDSoNjVf5lIFRSXGcIV5Lg3rR6iQIEJUX88moEDLHpqy31TZiqOGMIh23MMZq814WMijN7OPEYzDl6VDC4kvZIeCp1IR7hHGHzClQBg9tW2Bw2yOtzHbSPktiU1OUcYjKvpsZFTDwI5ARzWpOeipC68kgX3DIBHaBy0IS0xNnpm+/Ul9IAMJqA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Sun, 27 Jun
 2021 23:20:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Sun, 27 Jun 2021
 23:20:28 +0000
Date:   Sun, 27 Jun 2021 20:20:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH] vfio/mtty: Enforce available_instances
Message-ID: <20210627232027.GB4459@nvidia.com>
References: <162465624894.3338367.12935940647049917981.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162465624894.3338367.12935940647049917981.stgit@omen>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0425.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0425.namprd13.prod.outlook.com (2603:10b6:208:2c3::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Sun, 27 Jun 2021 23:20:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lxe4h-000Sux-MY; Sun, 27 Jun 2021 20:20:27 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5e55e8a-fe9e-4ac0-a54d-08d939c226a5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5380A35A365E9CA19AE8150FC2049@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nKVKlq3YCugWdKoo8bdRvnL5GC+1StlYTPvgauOgItzG8nt52SDQk5t1WXM4RFogUj/CV3yynuTqWCjbHu1RhXSsJqEKtY9genol556OVyHf0P0AHV6MoebU0Ixtt98mCvpH+4/c/qIGQsvNHX4gDMgVuisrPytcj/KjlhWbgo8DgmygOPdU6Atk4XwwGpoxP3hpPDVeTpobiFSoBL6VCfY8kkMyalXTqZR24isMlOk3dBQXcMKeU2bd//FajZCdzY3MtDoNx1Mqskgpjie6NRuTZ4yUH4cK7l8BKhsZ5IM0on6cfnRTW87dH6PP3peSolOgoFtPBgwO3ZRRVszUJfuyDWCiNvYBBzsHbMlwt2g5Pg+Zw4Zww45D73sutaTxENBhgWipABJRqFO6DX/u2W7NP7G+DbOj+CxTltTHTpNWetz1yqs7CnQ1ruRmdhxlRiKDQtfot4fn/fvBblnNhRRj7zTWFGaXnyRzVmXWVaZJzj3YWQys1wYmutebnmncmJxqpVZ4zUb0VJKzug9RAv+6QvX+ZMkS78W0ybZmf/1vNQezog+3GLxnXx9r/EmFw/nRKgQpij+b5hT94+c57MGgeXlmFW07Rv0aUoeHjRQIDePv64z358bs4nfnx1GItek58dKvEIKIcdf6pUW3GOK0IvJHYlDblON0Qp77MeO0iX8pOMT5b2DMwboEgZuxUjqIZDwq4Z5m79s0LV+aaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(316002)(9786002)(426003)(26005)(33656002)(186003)(4326008)(83380400001)(9746002)(38100700002)(2906002)(478600001)(4744005)(8676002)(5660300002)(2616005)(86362001)(66946007)(8936002)(36756003)(1076003)(66556008)(66476007)(6916009)(131093003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AslUTr/x/4qExCbmQKgFdjYTcHd2j0B4xhv/Rtlg7IWoYpYSaFQcyxbbs8Tj?=
 =?us-ascii?Q?Rj/w6CfDtk+NjTktouanI51XB9/thDV5qRz61C8OtRdFYmeaMG7g04lzdJEd?=
 =?us-ascii?Q?skSgJDkpMAFy0ABGrQ2MORr6C7UjeZEnN9kmo2OFNV65NvaIAVXydqIrhMBN?=
 =?us-ascii?Q?xp3DcE4ofgbouwfUVf4Fuu0XbtZUC/BKWNPebdfPB1FRUH5kM/kjndYt1Ypi?=
 =?us-ascii?Q?1QePdPTIxC5zFsXWDXknkQ5JOIADL9PlcLy6u0NmQQgm9OP4TEvGi/ajo2KS?=
 =?us-ascii?Q?9iOBpSyiGqwzOvAPYpxN7KXXwICNbLAYWqBUfyKtC5hzG2TLwxaNjg1B/KFW?=
 =?us-ascii?Q?qjMZAhE2Dx+7oj+Bdp6W8ygPcmrgD9YVlr+k3Cd6QaEr3Ab+V4f3r8ii4VpV?=
 =?us-ascii?Q?M5fzwqWDf0TtkKGLLcLbjAjy457FFbaAAssbhl+TbPFSzg2yfJyNb6pFxO6i?=
 =?us-ascii?Q?w5dg3beo2EwgudJTp41v661Car7lrTQO6pOHGQ+dFfDhhNZzVffxG2IlWrv2?=
 =?us-ascii?Q?FDBo7WcCM4J62dTY6Wncwri+2P2M2XdvP2hVmSMldcklwUrIzQKoas/kyKqI?=
 =?us-ascii?Q?PDYJqXzevWPMMDht8h92nGxzFn3BB+t0hFGgJgCSxgQOR8cU1Jd2QXTcoM1i?=
 =?us-ascii?Q?UrU0cRe+hkPELj6f3vlj+bK3wX3i+9rSeiwfl8gwl8OTHFTRD8xTi8hQYRnm?=
 =?us-ascii?Q?dHz21KthvRagB4GPTYxbNauLrwl3zduxDANqUk++ROz9sAbGarGrWBwSlGTN?=
 =?us-ascii?Q?Lg1MwkZJvg/h9Z30xdiT+JW+imOzEQ/mY/7PdMlhtFJ2Jmsm1AOAGvxMBO/P?=
 =?us-ascii?Q?k8TBXrqT3/F7Uc9v+V7Dvsf/JGJUTqpxYGkBRZrDBfWNeNHhdgRQrOmLHRsp?=
 =?us-ascii?Q?Ugps+O5Bfzw0A502j3XiQn7XsiWLkwDe9kOXJh66owGHIxaGmZQyUZJABB1E?=
 =?us-ascii?Q?R/b6r1OLflVXH7boTtGRFzmuxwwIN40ljZ0Jjm9WmnEGwyH+cT9L5TGmdd8f?=
 =?us-ascii?Q?hkdMHEtEu8tPp1buhriQiyf7q9SA50eRdyNgW/NHcEkCiqNyLqVM8NiYjBxv?=
 =?us-ascii?Q?RFkF54XZGHyxFU4dVF2SpXrK43tnly75d8VhQhId8h30hzzVf/ZP91hXjrnl?=
 =?us-ascii?Q?xabeH24vWmL3WlmDYBb+SmuBh9z0jxQJER3J+78IFMoQUX0LzIBB3cnerfov?=
 =?us-ascii?Q?B2qqOSzvoNP1tS7cfUCV/al2imxGVJxbyVwNWT2Ixe9TODycXn3SSq+6U0QO?=
 =?us-ascii?Q?SX/cbWgvQLcaPX9prjJmKwwbghahmzPbdE9uDyGQL5SaCpRIahp/bLDPh3my?=
 =?us-ascii?Q?ly4cCufcKs9dwaBSOTYHCNM1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e55e8a-fe9e-4ac0-a54d-08d939c226a5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2021 23:20:28.6097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npG+9/5uq+M1mpeqTY7TzOY1Ceq1y82gbXruYAOcNRce9lJ/GvUq03pjTwDlxNMp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 03:26:11PM -0600, Alex Williamson wrote:
> The sample mtty mdev driver doesn't actually enforce the number of
> device instances it claims are available.  Implement this properly.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Applies to vfio next branch + Jason's atomic conversion
> 
>  samples/vfio-mdev/mtty.c |   22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
